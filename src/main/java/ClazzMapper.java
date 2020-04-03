import com.github.javaparser.ast.body.TypeDeclaration;
import com.github.javaparser.ast.expr.AnnotationExpr;
import org.apache.commons.lang3.StringUtils;

import java.util.*;
import java.util.concurrent.atomic.AtomicReference;

/**
 * @author 徐书迪
 * @date 2020/4/1
 */
public class ClazzMapper {
//    注解@ApiModel
    private static final String CLASS_NAME_ANNOTATION_NAME = "ApiModel";
//    注解@ApiModel value
    private static final String CLASS_NAME_ANNOTATION_VALUE_KEY = "value";
//    注解@Table
    private static final String TABLE_ANNOTATION_NAME = "Table";

    /**
     * 类结构解析转换
     * 类上必须被标注@ApiModel和@Table
     * @param clazzPos
     * @return
     */
    public static List<GeneratorModulePo> clazzPo2GeneratorModulePo(Collection<ClazzPo> clazzPos) {
        List<GeneratorModulePo> generatorModulePos  = new ArrayList<>();
        for (ClazzPo clazzPo : clazzPos){
            if (isAnnotation(clazzPo,TABLE_ANNOTATION_NAME) && isAnnotation(clazzPo,CLASS_NAME_ANNOTATION_NAME)){
                GeneratorModulePo generatorModulePo = clazzPo2GeneratorModulePo(clazzPo);
                generatorModulePos.add(generatorModulePo);
            }
        }
        return generatorModulePos;
    }

    /**
     * 类结构解析转换
     *
     * @param clazzPo
     * @return
     */
    private static GeneratorModulePo clazzPo2GeneratorModulePo(ClazzPo clazzPo) {
        AtomicReference<String> modelZhName = new AtomicReference<>("");
        TypeDeclaration<?> typeDeclaration = clazzPo.getTypeDeclaration();
        typeDeclaration.getAnnotationByName(CLASS_NAME_ANNOTATION_NAME).ifPresent(annotationExpr -> {
            annotationExpr.ifSingleMemberAnnotationExpr(singleMemberAnnotationExpr -> {
                modelZhName.set(singleMemberAnnotationExpr.getMemberValue().toString().replaceAll("\"", ""));
            });
            annotationExpr.ifNormalAnnotationExpr(normalAnnotationExpr -> {
                normalAnnotationExpr.getPairs().forEach(memberValuePair -> {
                    if (Objects.equals(memberValuePair.getName().toString(), CLASS_NAME_ANNOTATION_VALUE_KEY)) {
                        modelZhName.set(memberValuePair.getValue().toString().replaceAll("\"", ""));
                    }
                });
            });
        });

        GeneratorModulePo generatorModulePo = new GeneratorModulePo();
        generatorModulePo.setName(typeDeclaration.getName().asString());
        generatorModulePo.setNameZh(modelZhName.get());
        typeDeclaration.getFullyQualifiedName().ifPresent(s -> {
            generatorModulePo.setPackageName(s.replace("." + typeDeclaration.getName().asString(), ""));
        });
        generatorModulePo.setPk(getPkName(clazzPo.getFieldPos()));
        generatorModulePo.setFieldPos(generatorFieldPos(clazzPo.getFieldPos()));
        return generatorModulePo;
    }
    private static boolean isAnnotation(ClazzPo clazzPo,String aName){
        TypeDeclaration<?> typeDeclaration = clazzPo.getTypeDeclaration();
        Optional<AnnotationExpr>  optionalAnnotationExpr = typeDeclaration.getAnnotationByName(aName);
        return optionalAnnotationExpr.isPresent();
    }

    private static String getPkName(List<FieldPo> fieldPos) {
        String pk = "";
        for (FieldPo fieldPo : fieldPos) {
            for (AnnotationExpr annotationExpr : fieldPo.getAnnotations()) {
                if (Objects.equals(annotationExpr.getName().toString(), "Id")) {
                    pk = fieldPo.getVariables().toString();

                }
            }
        }
        return pk;
    }

    private static List<GeneratorFieldPo> generatorFieldPos(List<FieldPo> fieldPos) {
        List<GeneratorFieldPo> generatorFieldPos = new ArrayList<>();
        for (FieldPo fieldPo : fieldPos) {
            GeneratorFieldPo generatorFieldPo = new GeneratorFieldPo();
            generatorFieldPo.setName(fieldPo.getVariables().getName().toString());
            generatorFieldPo.setDataType(fieldPo.getVariables().getType().toString());
            generatorFieldPo.setNameZh(getAnnotationValue(fieldPo.getAnnotations(), "ApiModelProperty", "value"));
            generatorFieldPo.setWidgetType(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "widgetType"));
            generatorFieldPo.setWidth(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "width"));
            generatorFieldPo.setNewState(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "newState"));
            generatorFieldPo.setUpdateState(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "updateState"));
            generatorFieldPo.setDictCode(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "dictCode"));
            generatorFieldPo.setQuery(Boolean.parseBoolean(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "query")));
            generatorFieldPo.setRequired(Boolean.parseBoolean(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "required")));
            if (StringUtils.isEmpty(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "listShow"))) {
                generatorFieldPo.setListShow(true);
            } else {
                generatorFieldPo.setListShow(Boolean.parseBoolean(getAnnotationValue(fieldPo.getAnnotations(), "XProperty", "listShow")));
            }
            if (StringUtils.isNotBlank(generatorFieldPo.getNameZh())) {
                generatorFieldPos.add(generatorFieldPo);
            }

        }
        return generatorFieldPos;
    }

    private static String getAnnotationValue(List<AnnotationExpr> annotationExprs, String annotationName, String key) {

        AtomicReference<String> result = new AtomicReference<>("");
        annotationExprs.forEach(annotationExpr -> {
            if (Objects.equals(annotationExpr.getName().toString(), annotationName)) {
                annotationExpr.ifSingleMemberAnnotationExpr(singleMemberAnnotationExpr -> {
                    result.set(singleMemberAnnotationExpr.getMemberValue().toString().replaceAll("\"", ""));
                });
                annotationExpr.ifNormalAnnotationExpr(normalAnnotationExpr -> {
                    normalAnnotationExpr.getPairs().forEach(memberValuePair -> {
                        if (Objects.equals(memberValuePair.getName().toString(), key)) {
                            result.set(memberValuePair.getValue().toString().replaceAll("\"", ""));
                        }
                    });
                });
            }
        });
        return result.get();
    }
}
