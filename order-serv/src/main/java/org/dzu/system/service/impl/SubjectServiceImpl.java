package org.dzu.system.service.impl;

import org.dzu.common.utils.DateUtils;
import org.dzu.system.domain.Subject;
import org.dzu.system.mapper.SubjectMapper;
import org.dzu.system.service.ISubjectService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
/**
 * 科目Service业务层处理
 *
 * @author ml
 * @date 2024-08-02
 */
@Service
public class SubjectServiceImpl implements ISubjectService
{
    @Autowired
    private SubjectMapper subjectMapper;

    /**
     * 查询科目
     *
     * @param id 科目主键
     * @return 科目
     */
    @Override
    public Subject selectSubjectById(Long id)
    {
        return subjectMapper.selectSubjectById(id);
    }

    /**
     * 查询科目列表
     *
     * @param subject 科目
     * @return 科目
     */
    @Override
    public List<Subject> selectSubjectList(Subject subject)
    {
        return subjectMapper.selectSubjectList(subject);
    }

    /**
     * 新增科目
     *
     * @param subject 科目
     * @return 结果
     */
    @Override
    public int insertSubject(Subject subject)
    {
        subject.setCreateTime(DateUtils.getNowDate());
        return subjectMapper.insertSubject(subject);
    }

    /**
     * 修改科目
     * 
     * @param subject 科目
     * @return 结果
     */
    @Override
    public int updateSubject(Subject subject)
    {
        subject.setUpdateTime(DateUtils.getNowDate());
        return subjectMapper.updateSubject(subject);
    }

    /**
     * 批量删除科目
     * 
     * @param ids 需要删除的科目主键
     * @return 结果
     */
    @Override
    public int deleteSubjectByIds(Long[] ids)
    {
        return subjectMapper.deleteSubjectByIds(ids);
    }

    /**
     * 删除科目信息
     * 
     * @param id 科目主键
     * @return 结果
     */
    @Override
    public int deleteSubjectById(Long id)
    {
        return subjectMapper.deleteSubjectById(id);
    }
}
