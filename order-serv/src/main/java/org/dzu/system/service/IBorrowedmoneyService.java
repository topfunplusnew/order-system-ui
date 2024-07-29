package org.dzu.system.service;

import java.util.List;
import org.dzu.system.domain.Borrowedmoney;

/**
 * 从外部借入款、贷款Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBorrowedmoneyService 
{
    /**
     * 查询从外部借入款、贷款
     * 
     * @param id 从外部借入款、贷款主键
     * @return 从外部借入款、贷款
     */
    public Borrowedmoney selectBorrowedmoneyById(Long id);

    /**
     * 查询从外部借入款、贷款列表
     * 
     * @param borrowedmoney 从外部借入款、贷款
     * @return 从外部借入款、贷款集合
     */
    public List<Borrowedmoney> selectBorrowedmoneyList(Borrowedmoney borrowedmoney);

    /**
     * 新增从外部借入款、贷款
     * 
     * @param borrowedmoney 从外部借入款、贷款
     * @return 结果
     */
    public int insertBorrowedmoney(Borrowedmoney borrowedmoney);

    /**
     * 修改从外部借入款、贷款
     * 
     * @param borrowedmoney 从外部借入款、贷款
     * @return 结果
     */
    public int updateBorrowedmoney(Borrowedmoney borrowedmoney);

    /**
     * 批量删除从外部借入款、贷款
     * 
     * @param ids 需要删除的从外部借入款、贷款主键集合
     * @return 结果
     */
    public int deleteBorrowedmoneyByIds(Long[] ids);

    /**
     * 删除从外部借入款、贷款信息
     * 
     * @param id 从外部借入款、贷款主键
     * @return 结果
     */
    public int deleteBorrowedmoneyById(Long id);
}
