package cn.dreamcatchers.xframe.serve.repository;

import ${root.packageName}.${root.name};
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

/**
 * ${root.nameZh}
 *
 */
public interface ${root.name}Repository extends JpaRepository<${root.name}, Long>, JpaSpecificationExecutor<${root.name}> {
}
