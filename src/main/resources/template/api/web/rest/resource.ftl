<#function camelToDashed(s)>
    <#return s
    <#-- "fooBar" to "foo_bar": -->
    ?replace('([a-z])([A-Z])', '$1_$2', 'r')
    <#-- "FOOBar" to "FOO_Bar": -->
    ?replace('([A-Z])([A-Z][a-z])', '$1_$2', 'r')
    <#-- All of those to "FOO_BAR": -->
    ?lower_case
    >
</#function>
package cn.dreamcatchers.xframe.serve.web.rest;

import ${root.packageName}.${root.name};
import cn.dreamcatchers.xframe.serve.repository.${root.name}Repository;
import cn.dreamcatchers.xframe.serve.service.${root.name}Service;
import cn.dreamcatchers.xframe.serve.web.rest.errors.BadRequestAlertException;
import com.github.wenhao.jpa.Specifications;
import io.github.jhipster.web.util.ResponseUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

/**
 * ${root.nameZh}
 */
@Slf4j
@RequestMapping("/api/${camelToDashed(root.name)}")
@RestController
public class ${root.name}Resource {
    private final ${root.name}Repository repository;
    private final ${root.name}Service service;

    public ${root.name}Resource(${root.name}Repository repository, ${root.name}Service service) {
        this.repository = repository;
        this.service = service;
    }

    @GetMapping
    ResponseEntity<Page<${root.name}>> getList(Pageable pageable){
        //log可使用aop代替
        log.debug("REST request to get ${root.name}");
        //你可以在这里创建复杂或动态查询
        //https://github.com/wenhao/jpa-spec
        Specification<${root.name}> specification = Specifications.<${root.name}>and()
            .build();
        Page<${root.name}> page = repository.findAll(specification,pageable);
        return ResponseEntity.ok(page);
    }

    @GetMapping("/{id}")
    ResponseEntity<${root.name}> getOne(@PathVariable Long id) {
        log.debug("REST request to get ${root.name}");
        return ResponseUtil.wrapOrNotFound(repository.findById(id));
    }

    @PostMapping
    ResponseEntity<${root.name}> save(@Valid @RequestBody ${root.name} item){
        log.debug("REST request to save ${root.name} ");

        return ResponseEntity.ok(service.save(item));
    }

    @PutMapping
    ResponseEntity<${root.name}> update(@Valid @RequestBody ${root.name} item){
        log.debug("REST request to update ${root.name}");
        if (item.getId()==null){
            throw new BadRequestAlertException("${root.name} ID不存在", "${root.name}Management", "idnotexists");
        }
        return ResponseEntity.ok(service.update(item));
    }

    @DeleteMapping
    ResponseEntity<Void> delete(@RequestBody List<Long> ids){
        log.debug("REST request to delete ${root.name} : {}", ids);
        service.delete(ids);
        return ResponseEntity.noContent().build();
    }
}
