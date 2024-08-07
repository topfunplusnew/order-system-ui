package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.Auditflow;

import java.util.List;

/**
 * 审核流程Mapper接口
 * 
 * @author ml
 * @date 2024-08-01
 */
public interface AuditflowMapper extends BaseMapper<Auditflow>
{
    /**
     * 查询审核流程
     * 
     * @param id 审核流程主键
     * @return 审核流程
     */
    public Auditflow selectAuditflowById(Long id);

    /**
     * 查询审核流程列表
     * 
     * @param auditflow 审核流程
     * @return 审核流程集合
     */
    public List<Auditflow> selectAuditflowList(Auditflow auditflow);

    /**
     * 新增审核流程
     * 
     * @param auditflow 审核流程
     * @return 结果
     */
    public int insertAuditflow(Auditflow auditflow);

    /**
     * 修改审核流程
     * 
     * @param auditflow 审核流程
     * @return 结果
     */
    public int updateAuditflow(Auditflow auditflow);

    /**
     * 删除审核流程
     * 
     * @param id 审核流程主键
     * @return 结果
     */
    public int deleteAuditflowById(Long id);

    /**
     * 批量删除审核流程
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAuditflowByIds(Long[] ids);

    int insertBatch(List<Auditflow> auditflow);
}
