package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.AuditInfo;
import org.dzu.system.domain.PaymentApply;

/**
 * 审核流程Service接口
 * 
 * @author ml
 * @date 2024-08-01
 */
public interface IAuditInfoService 
{
    /**
     * 查询审核流程
     * 
     * @param id 审核流程主键
     * @return 审核流程
     */
    public AuditInfo selectAuditInfoById(Long id);

    /**
     * 查询审核流程列表
     * 
     * @param auditInfo 审核流程
     * @return 审核流程集合
     */
    public List<AuditInfo> selectAuditInfoList(AuditInfo auditInfo);

    /**
     * 新增审核流程
     * 
     * @param auditInfo 审核流程
     * @return 结果
     */
    public int insertAuditInfo(PaymentApply auditInfo);

    /**
     * 修改审核流程
     * 
     * @param auditInfo 审核流程
     * @return 结果
     */
    public int updateAuditInfo(AuditInfo auditInfo);

    /**
     * 批量删除审核流程
     * 
     * @param ids 需要删除的审核流程主键集合
     * @return 结果
     */
    public int deleteAuditInfoByIds(Long[] ids);

    /**
     * 删除审核流程信息
     * 
     * @param id 审核流程主键
     * @return 结果
     */
    public int deleteAuditInfoById(Long id);
}
