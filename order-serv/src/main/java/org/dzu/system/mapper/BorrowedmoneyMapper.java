package org.dzu.system.mapper;

import org.dzu.system.domain.Borrowedmoney;

import java.util.List;

/**
 * 借入金钱Mapper接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface BorrowedmoneyMapper 
{
    /**
     * 查询借入金钱
     * 
     * @param id 借入金钱主键
     * @return 借入金钱
     */
    public Borrowedmoney selectBorrowedmoneyById(Long id);

    /**
     * 查询借入金钱列表
     * 
     * @param borrowedmoney 借入金钱
     * @return 借入金钱集合
     */
    public List<Borrowedmoney> selectBorrowedmoneyList(Borrowedmoney borrowedmoney);

    /**
     * 新增借入金钱
     * 
     * @param borrowedmoney 借入金钱
     * @return 结果
     */
    public int insertBorrowedmoney(Borrowedmoney borrowedmoney);

    /**
     * 修改借入金钱
     * 
     * @param borrowedmoney 借入金钱
     * @return 结果
     */
    public int updateBorrowedmoney(Borrowedmoney borrowedmoney);

    /**
     * 删除借入金钱
     * 
     * @param id 借入金钱主键
     * @return 结果
     */
    public int deleteBorrowedmoneyById(Long id);

    /**
     * 批量删除借入金钱
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteBorrowedmoneyByIds(Long[] ids);
}
