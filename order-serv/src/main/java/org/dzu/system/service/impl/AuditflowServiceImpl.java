package org.dzu.system.service.impl;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.AuditflowMapper;
import org.dzu.system.domain.Auditflow;
import org.dzu.system.service.IAuditflowService;
/**
 * 审核流程Service业务层处理
 *
 * @author ml
 * @date 2024-08-01
 */
@Service
public class AuditflowServiceImpl implements IAuditflowService
{
    @Autowired
    private AuditflowMapper auditflowMapper;

    /**
     * 查询审核流程
     *
     * @param id 审核流程主键
     * @return 审核流程
     */
    @Override
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
    @Override
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
    @Override
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
    @Override
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
    @Override
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
    @Override
    public int deleteAuditflowById(Long id)
    {
        return auditflowMapper.deleteAuditflowById(id);
    }
}
