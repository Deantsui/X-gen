package cn.dreamcatchers.xframe.serve.service.impl;

import ${root.packageName}.${root.name};
import cn.dreamcatchers.xframe.serve.repository.${root.name}Repository;
import cn.dreamcatchers.xframe.serve.service.${root.name}Service;
import cn.dreamcatchers.xframe.serve.web.rest.errors.BadRequestAlertException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cn.dreamcatchers.xframe.serve.utils.BeanUtil;

import java.util.List;

/**
 * ${root.nameZh}
 */
@Service
@Slf4j
@Transactional(rollbackFor = Throwable.class)
public class ${root.name}ServiceImpl implements ${root.name}Service {
    private final ${root.name}Repository repository;

    public ${root.name}ServiceImpl(${root.name}Repository repository) {
        this.repository = repository;
    }

    @Override
    public ${root.name} save(${root.name} item) {
        ${root.name} result = repository.save(item);
        return result;
    }

    @Override
    public ${root.name} update(${root.name} item) {
        ${root.name} result = repository.findById(item.getId())
            .orElseThrow(()-> new BadRequestAlertException("${root.nameZh}不存在!", "${root.name}Management", "${root.name}notexists"));
        BeanUtil.copyPropertiesIgnoreNull(item,result);
        return result;
    }

    @Override
    public void delete(List<Long> ids) {
        for (Long id : ids){
            ${root.name} result = repository.findById(id)
                .orElseThrow(()-> new BadRequestAlertException("${root.nameZh}不存在!", "${root.name}Management", "${root.name}notexists"));
            repository.delete(result);
        }
    }
}
