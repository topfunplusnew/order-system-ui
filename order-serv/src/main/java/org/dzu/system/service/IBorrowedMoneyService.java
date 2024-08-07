package org.dzu.system.service;

import org.dzu.system.domain.BorrowedMoney;

import java.util.List;

/**
 * 从外部借款信息Service接口
 * 
 * @author ml
 * @date 2024-07-29
 */
public interface IBorrowedMoneyService 
{
    /**
     * 查询从外部借款信息
     * 
     * @param id 从外部借款信息主键
     * @return 从外部借款信息
     */
    public BorrowedMoney selectBorrowedMoneyById(Long id);

    /**
     * 查询从外部借款信息列表
     * 
     * @param borrowedMoney 从外部借款信息
     * @return 从外部借款信息集合
     */
    public List<BorrowedMoney> selectBorrowedMoneyList(BorrowedMoney borrowedMoney);

    /**
     * 新增从外部借款信息
     * 
     * @param borrowedMoney 从外部借款信息
     * @return 结果
     */
    public int insertBorrowedMoney(BorrowedMoney borrowedMoney);

    /**
     * 修改从外部借款信息
     * 
     * @param borrowedMoney 从外部借款信息
     * @return 结果
     */
    public int updateBorrowedMoney(BorrowedMoney borrowedMoney);

    /**
     * 批量删除从外部借款信息
     * 
     * @param ids 需要删除的从外部借款信息主键集合
     * @return 结果
     */
    public int deleteBorrowedMoneyByIds(Long[] ids);

    /**
     * 删除从外部借款信息信息
     * 
     * @param id 从外部借款信息主键
     * @return 结果
     */
    public int deleteBorrowedMoneyById(Long id);


    public BorrowedMoney seleteBorrowedMoneyByUUID(String  uuid);

    void updateBorrowedMoneyIsEndByLoanNO(String loanNO);
}
