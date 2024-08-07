package org.dzu.system.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.dzu.system.domain.Subject;

import java.util.List;

/**
 * 科目Mapper接口
 * 
 * @author ml
 * @date 2024-08-02
 */
public interface SubjectMapper extends BaseMapper<Subject>
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
     * 删除科目
     * 
     * @param id 科目主键
     * @return 结果
     */
    public int deleteSubjectById(Long id);

    /**
     * 批量删除科目
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteSubjectByIds(Long[] ids);
}
