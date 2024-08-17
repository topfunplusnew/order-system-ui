package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.exception.ServiceException;
import org.dzu.system.domain.Auditflow;
import org.dzu.system.mapper.AuditInfoMapper;
import org.dzu.system.mapper.AuditflowMapper;
import org.dzu.system.service.IAuditInfoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 审核流程Service业务层处理
 *
 * @author ml
 * @date 2024-08-01
 */
@Service
public class AuditflowServiceImpl {
    @Autowired
    private AuditflowMapper auditflowMapper;

    @Autowired
    private IAuditInfoService auditInfoService;
    /**
     * 查询审核流程
     *
     * @param id 审核流程主键
     * @return 审核流程
     */
    public Auditflow selectAuditflowById(Long id)
    {
        return auditflowMapper.selectAuditflowById(id);
    }

    /**
     * 查询审核流程列表
     *
     * @param auditflow 审核流程
     * @return 审核流程
     */
    public List<Auditflow> selectAuditflowList(Auditflow auditflow)
    {
        return auditflowMapper.selectAuditflowList(auditflow);
    }

    /**
     * 新增审核流程
     *
     * @param auditflow 审核流程
     * @return 结果
     */
    public int insertAuditflow(Auditflow auditflow)
    {
        return auditflowMapper.insertAuditflow(auditflow);
    }

    /**
     * 修改审核流程
     * 
     * @param auditflow 审核流程
     * @return 结果
     */
    public int updateAuditflow(Auditflow auditflow)
    {
        return auditflowMapper.updateAuditflow(auditflow);
    }

    /**
     * 批量删除审核流程
     * 
     * @param ids 需要删除的审核流程主键
     * @return 结果
     */
    public int deleteAuditflowByIds(Long[] ids)
    {
        return auditflowMapper.deleteAuditflowByIds(ids);
    }

    /**
     * 删除审核流程信息
     * 
     * @param id 审核流程主键
     * @return 结果
     */
    public int deleteAuditflowById(Long id)
    {
        return auditflowMapper.deleteAuditflowById(id);
    }

    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)// 开启最高级别的事务隔离和最小容忍异常
    public int put(List<Auditflow> auditflow) {
        // 判断步骤编号必须是从1开始，且连续
        for (int j = 0; j < auditflow.size(); j++) {
            if (auditflow.get(j).getStep() != j + 1) {
                throw new ServiceException("步骤编号必须是从1开始，且连续");
            }
        }

        // 全部删除
        auditflowMapper.delete(null);

        // 重新插入
        int i = 0;
        try {
            i = auditflowMapper.insertBatch(auditflow);
        } catch (DuplicateKeyException e) {
            throw new ServiceException("步骤编号重复");
        }

        // 重新设置总页数
        Auditflow update = new Auditflow();
        update.setStepnum(Long.valueOf(auditflow.size()));
        auditflowMapper.update(update,null);


        // 将当前的所有审核流程设置为未通过
        auditInfoService.updateAuditInfoToError();



        return i;
    }

    public Auditflow selectAuditflowByStep(long l) {
        QueryWrapper<Auditflow> query = new QueryWrapper<>();
        query.eq("step", l);
        return auditflowMapper.selectOne(query);
    }
}
