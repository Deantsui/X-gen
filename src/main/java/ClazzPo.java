import com.github.javaparser.ast.body.TypeDeclaration;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by 徐书迪 on 2020/4/1.
 */
public class ClazzPo {
    public ClazzPo(TypeDeclaration<?> typeDeclaration, List<FieldPo> fieldPos) {
        this.typeDeclaration = typeDeclaration;
        this.fieldPos = fieldPos;
    }

    public ClazzPo(TypeDeclaration<?> typeDeclaration) {
        this.typeDeclaration = typeDeclaration;
    }

    private TypeDeclaration<?> typeDeclaration;
    private List<FieldPo> fieldPos = new ArrayList<>();

    public TypeDeclaration<?> getTypeDeclaration() {
        return typeDeclaration;
    }

    public void setTypeDeclaration(TypeDeclaration<?> typeDeclaration) {
        this.typeDeclaration = typeDeclaration;
    }

    public List<FieldPo> getFieldPos() {
        return fieldPos;
    }

    public void setFieldPos(List<FieldPo> fieldPos) {
        this.fieldPos = fieldPos;
    }
}
