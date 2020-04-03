import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author 徐书迪
 * @date 2020/4/2
 */
public class XExtension {
    private String domainPath;
    private List<String> excludeFile = new ArrayList<>();
    private String outputPath;

    public XExtension(String domainPath, List<String> excludeFile, String outputPath) {
        this.domainPath = domainPath;
        this.excludeFile = excludeFile;
        this.outputPath = outputPath;
    }

    public XExtension(String domainPath, List<String> excludeFile) {
        this.domainPath = domainPath;
        this.excludeFile = excludeFile;
    }

    public XExtension(String domainPath) {
        this.domainPath = domainPath;
    }

    public XExtension() {
    }

    public String getDomainPath() {
        return domainPath;
    }

    public void setDomainPath(String domainPath) {
        this.domainPath = domainPath;
    }

    public List<String> getExcludeFile() {
        return excludeFile;
    }

    public void setExcludeFile(List<String> excludeFile) {
        this.excludeFile = excludeFile;
    }

    public String getOutputPath() {
        return outputPath;
    }

    public void setOutputPath(String outputPath) {
        this.outputPath = outputPath;
    }

    @Override
    public String toString() {
        return "XExtension{" +
                "domainPath='" + domainPath + '\'' +
                ", excludeFile=" + excludeFile +
                '}';
    }
}
