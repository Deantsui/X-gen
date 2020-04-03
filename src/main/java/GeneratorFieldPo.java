/**
 *
 * @author 徐书迪
 * @date 2020/4/1
 */
public class GeneratorFieldPo {


    /**
     * 字段名称
     */
    private String name;
    /**
     * 字段中文名称
     */
    private String nameZh;
    /**
     * 字段数据类型
     */
    private String dataType;
    /**
     * 组件类型
     */
    private String widgetType;
    /**
     * 字典编码
     */
    private String dictCode;
    /**
     * 宽度
     */
    private String width;
    /**
     * 新增状态
     */
    private String newState;
    /**
     * 更新状态
     */
    private String updateState;
    /**
     * 是否查询
     */
    private boolean query;
    /**
     * 列表是否显示
     */
    private boolean listShow;
    /**
     * 编辑是否显示
     */
    private boolean editShow = true;
    /**
     * 是否必填
     */
    private boolean required;

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

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getWidgetType() {
        return widgetType;
    }

    public void setWidgetType(String widgetType) {
        this.widgetType = widgetType;
    }

    public String getWidth() {
        return width;
    }

    public void setWidth(String width) {
        this.width = width;
    }

    public String getNewState() {
        return newState;
    }

    public void setNewState(String newState) {
        this.newState = newState;
    }

    public String getUpdateState() {
        return updateState;
    }

    public void setUpdateState(String updateState) {
        this.updateState = updateState;
    }

    public boolean isQuery() {
        return query;
    }

    public void setQuery(boolean query) {
        this.query = query;
    }

    public boolean isListShow() {
        return listShow;
    }

    public void setListShow(boolean listShow) {
        this.listShow = listShow;
    }

    public boolean isRequired() {
        return required;
    }

    public void setRequired(boolean required) {
        this.required = required;
    }

    public String getDictCode() {
        return dictCode;
    }

    public void setDictCode(String dictCode) {
        this.dictCode = dictCode;
    }

    public boolean isEditShow() {
        return editShow;
    }

    public void setEditShow(boolean editShow) {
        this.editShow = editShow;
    }
}
