import com.github.javaparser.StaticJavaParser;
import com.github.javaparser.ast.CompilationUnit;
import com.github.javaparser.ast.body.FieldDeclaration;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import freemarker.template.TemplateExceptionHandler;
import org.apache.commons.lang3.StringUtils;
import org.gradle.api.Plugin;
import org.gradle.api.Project;
import org.gradle.api.Task;
import org.gradle.api.file.SourceDirectorySet;
import org.gradle.api.plugins.JavaPluginConvention;

import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author DeanTsui
 * @date 2020/3/31
 */
public class XPlugin implements Plugin<Project> {
    @Override
    public void apply(Project project) {
        Task task = project.task("generator");
        task.setGroup("x-frame");
        project.getExtensions().create("generator", XExtension.class);
        task.doFirst(task1 -> {
            XExtension xExtension = (XExtension) project.getExtensions().getByName("generator");
            SourceDirectorySet mainSourceSet = project.getConvention()
                    .getPlugin(JavaPluginConvention.class)
                    .getSourceSets()
                    .getByName("main")
                    .getAllJava();
            List<File> fileList = new ArrayList<>();
            for (File file : mainSourceSet) {
                if (isSkipTargetPath(file, xExtension)) {
                    continue;
                }
                fileList.add(file);
            }
            List<ClazzPo> clazzPos = ast(fileList);
            List<GeneratorModulePo> generatorModulePos = ClazzMapper.clazzPo2GeneratorModulePo(clazzPos);
//            gen(generatorModulePos);
            genDomain(xExtension.getOutputPath(), generatorModulePos);
        });
    }

    /**
     * 跳过
     *
     * @param file
     * @return
     */
    private boolean isSkipTargetPath(File file, XExtension xExtension) {
//        String suffixPath = "cn/dreamcatchers/xframe/serve/domain/";
//        List<String> excludeFile = new ArrayList<>();
        String lombookPath = "/annotationProcessor/";
        if (file.toString().contains(lombookPath)) {
            return true;
        }
        if (!StringUtils.contains(file.toString(), xExtension.getDomainPath())) {
            return true;
        }
        for (String filep : xExtension.getExcludeFile()) {
            if (StringUtils.contains(file.toString(), filep)) {
                return true;
            }
        }
        return false;
    }

    /**
     * 初步语法解析
     *
     * @param files
     * @return
     */
    private List<ClazzPo> ast(List<File> files) {
        List<ClazzPo> clazzPos = new ArrayList<>();
        try {
            for (File file : files) {
                CompilationUnit cu = StaticJavaParser.parse(file);
                cu.getTypes().forEach(typeDeclaration -> {
                    List<FieldPo> fieldPos = new ArrayList<>();
                    ClazzPo clazzPo = new ClazzPo(typeDeclaration, fieldPos);
                    clazzPos.add(clazzPo);
                    typeDeclaration.findAll(FieldDeclaration.class).forEach(field -> {
                        FieldPo fieldpo = new FieldPo();
                        fieldPos.add(fieldpo);
                        field.getAnnotations().forEach(annotationExpr -> {
                            fieldpo.getAnnotations().add(annotationExpr);
                        });
                        field.getVariables().forEach(fieldpo::setVariables);
                    });
                });
            }


        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return clazzPos;
    }

    public static void main(String[] args) {

    }

    /**
     * 代码生成
     */
    private void genDomain(String outputPath, List<GeneratorModulePo> generatorModulePos) {

        Configuration cfg = initGenEngine(new File("src/main/resources/template"));
        for (GeneratorModulePo generatorModulePo : generatorModulePos) {
            genApi(generatorModulePo, outputPath, cfg);
            genWeb(generatorModulePo, outputPath, cfg);
        }
        genWebMR(generatorModulePos,outputPath,cfg);
    }

    /**
     * 后端生成
     * @param generatorModulePo
     * @param outputPath
     * @param cfg
     */
    private void genApi(GeneratorModulePo generatorModulePo, String outputPath, Configuration cfg) {
        String apiRFileDir = outputPath + "/api/repository/";
        genByTemplate(cfg, "api/repository/repository.ftl",
                generatorModulePo, apiRFileDir, generatorModulePo.getName() + "Repository.java");
        String apiSFileDir = outputPath + "/api/service/";
        genByTemplate(cfg, "api/service/service.ftl",
                generatorModulePo, apiSFileDir, generatorModulePo.getName() + "Service.java");
        String apiSIFileDir = outputPath + "/api/service/impl/";
        genByTemplate(cfg, "api/service/impl/serviceImpl.ftl",
                generatorModulePo, apiSIFileDir, generatorModulePo.getName() + "ServiceImpl.java");
        String apiWFileDir = outputPath + "/api/web/rest/";
        genByTemplate(cfg, "api/web/rest/resource.ftl",
                generatorModulePo, apiWFileDir, generatorModulePo.getName() + "Resource.java");
    }

    /**
     * 前端-业务生成
     * @param generatorModulePo
     * @param outputPath
     * @param cfg
     */
    private void genWeb(GeneratorModulePo generatorModulePo, String outputPath, Configuration cfg) {
        String webDir = outputPath + "/web/" + generatorModulePo.getName() + "/";
        genByTemplate(cfg, "web/index.js.ftl", generatorModulePo, webDir,
                 "index.js");
        genByTemplate(cfg, "web/config.js.ftl", generatorModulePo, webDir,
                 "config.js");
        genByTemplate(cfg, "web/model/Model.js.ftl", generatorModulePo, webDir+"/model/",
                 "Model.js");
        genByTemplate(cfg, "web/action/Action.js.ftl", generatorModulePo, webDir+"/action/",
                 "Action.js");
        genByTemplate(cfg, "web/components/edit/Edit.js.ftl", generatorModulePo, webDir+"/components/edit/",
                 "Edit.js");
        genByTemplate(cfg, "web/components/edit/Edit.less.ftl", generatorModulePo, webDir+"/components/edit/",
                 "Edit.less");
        genByTemplate(cfg, "web/components/list/List.js.ftl", generatorModulePo, webDir+"/components/list/",
                 "List.js");
        genByTemplate(cfg, "web/components/list/List.less.ftl", generatorModulePo, webDir+"/components/list/",
                 "List.less");
    }

    /**
     * 前端-路由、菜单生成
     * @param generatorModulePos
     * @param outputPath
     * @param cfg
     */
    private void genWebMR(List<GeneratorModulePo> generatorModulePos, String outputPath, Configuration cfg) {
        String webDir = outputPath + "/web/";
        genByTemplate(cfg, "/web/menu.js.ftl", generatorModulePos, webDir,
                "menu.js");
        genByTemplate(cfg, "/web/route.js.ftl", generatorModulePos, webDir,
                "route.js");
    }

        private Configuration initGenEngine(File file) {
        Configuration cfg = new Configuration(Configuration.VERSION_2_3_22);
        cfg.setClassForTemplateLoading(this.getClass(), "/template");
        cfg.setDefaultEncoding("UTF-8");
        cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);
        return cfg;
    }

    private void genByTemplate(Configuration cfg, String templateName, Object domain, String outFilePath, String outFileName) {
        Template temp = null;
        try {
            temp = cfg.getTemplate(templateName);

            Path dirPath = Paths.get(outFilePath);
            File file = dirPath.toFile();
            if (!file.exists()) {
                file.mkdirs();
            }
            Path filePath = Paths.get(outFilePath + outFileName);

            Writer writer = Files.newBufferedWriter(filePath, Charset.defaultCharset(),
                    StandardOpenOption.APPEND, StandardOpenOption.CREATE);

            Map root = new HashMap<String, Object>();
            root.put("root", domain);
            temp.process(root, writer);
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
        }
    }
}
