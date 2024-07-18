package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Borrowedmoney;

/**
 * 借入金钱Service接口
 * 
 * @author ml
 * @date 2024-07-18
 */
public interface IBorrowedmoneyService 
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
     * 批量删除借入金钱
     * 
     * @param ids 需要删除的借入金钱主键集合
     * @return 结果
     */
    public int deleteBorrowedmoneyByIds(Long[] ids);

    /**
     * 删除借入金钱信息
     * 
     * @param id 借入金钱主键
     * @return 结果
     */
    public int deleteBorrowedmoneyById(Long id);
}
