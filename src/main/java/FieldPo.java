import com.github.javaparser.ast.body.VariableDeclarator;
import com.github.javaparser.ast.expr.AnnotationExpr;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author 徐书迪
 * @date 2020/4/1
 */
public class FieldPo {
    private List<AnnotationExpr> annotations = new ArrayList<>();

    private VariableDeclarator variables;

    public List<AnnotationExpr> getAnnotations() {
        return annotations;
    }

    public void setAnnotations(List<AnnotationExpr> annotations) {
        this.annotations = annotations;
    }

    public VariableDeclarator getVariables() {
        return variables;
    }

    public void setVariables(VariableDeclarator variables) {
        this.variables = variables;
    }
}
