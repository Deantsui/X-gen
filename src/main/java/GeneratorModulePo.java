import java.util.ArrayList;
import java.util.List;

/**
 *
 */
public class GeneratorModulePo {
    /**
     * 模块名
     */
    private String name;
    /**
     * 模块中文名
     */
    private String nameZh;
    /**
     * 包名
     */
    private String packageName;
    /**
     * 主键名称
     */
    private String pk;
    /**
     * 字段
     */
    private List<GeneratorFieldPo> fieldPos = new ArrayList<>();


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameZh() {
        return nameZh;
    }

    public void setNameZh(String nameZh) {
        this.nameZh = nameZh;
    }

    public List<GeneratorFieldPo> getFieldPos() {
        return fieldPos;
    }

    public void setFieldPos(List<GeneratorFieldPo> fieldPos) {
        this.fieldPos = fieldPos;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName) {
        this.packageName = packageName;
    }

    public String getPk() {
        return pk;
    }

    public void setPk(String pk) {
        this.pk = pk;
    }

    @Override
    public String toString() {
        return "GeneratorModulePo{" +
                "name='" + name + '\'' +
                ", nameZh='" + nameZh + '\'' +
                ", packageName='" + packageName + '\'' +
                ", pk='" + pk + '\'' +
                ", fieldPos=" + fieldPos +
                '}';
    }
}
