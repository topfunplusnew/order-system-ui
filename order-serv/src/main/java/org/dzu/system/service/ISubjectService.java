package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Subject;

/**
 * 科目Service接口
 * 
 * @author ml
 * @date 2024-08-02
 */
public interface ISubjectService 
{
    /**
     * 查询科目
     * 
     * @param id 科目主键
     * @return 科目
     */
    public Subject selectSubjectById(Long id);

    /**
     * 查询科目列表
     * 
     * @param subject 科目
     * @return 科目集合
     */
    public List<Subject> selectSubjectList(Subject subject);

    /**
     * 新增科目
     * 
     * @param subject 科目
     * @return 结果
     */
    public int insertSubject(Subject subject);

    /**
     * 修改科目
     * 
     * @param subject 科目
     * @return 结果
     */
    public int updateSubject(Subject subject);

    /**
     * 批量删除科目
     * 
     * @param ids 需要删除的科目主键集合
     * @return 结果
     */
    public int deleteSubjectByIds(Long[] ids);

    /**
     * 删除科目信息
     * 
     * @param id 科目主键
     * @return 结果
     */
    public int deleteSubjectById(Long id);
}
