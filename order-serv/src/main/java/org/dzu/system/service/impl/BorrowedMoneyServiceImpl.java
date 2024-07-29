package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BorrowedMoneyMapper;
import org.dzu.system.domain.BorrowedMoney;
import org.dzu.system.service.IBorrowedMoneyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 从外部借款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BorrowedMoneyServiceImpl implements IBorrowedMoneyService
{
    @Autowired
    private BorrowedMoneyMapper borrowedMoneyMapper;

    /**
     * 查询从外部借款信息
     *
     * @param id 从外部借款信息主键
     * @return 从外部借款信息
     */
    @Override
    public BorrowedMoney selectBorrowedMoneyById(Long id)
    {
        return borrowedMoneyMapper.selectBorrowedMoneyById(id);
    }

    /**
     * 查询从外部借款信息列表
     *
     * @param borrowedMoney 从外部借款信息
     * @return 从外部借款信息
     */
    @Override
    public List<BorrowedMoney> selectBorrowedMoneyList(BorrowedMoney borrowedMoney)
    {
        return borrowedMoneyMapper.selectBorrowedMoneyList(borrowedMoney);
    }

    /**
     * 新增从外部借款信息
     *
     * @param borrowedMoney 从外部借款信息
     * @return 结果
     */
    @Override
    public int insertBorrowedMoney(BorrowedMoney borrowedMoney)
    {
        borrowedMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        borrowedMoney.setUserId(SecurityUtils.getUserId());
        borrowedMoney.setUserName(SecurityUtils.getUserTruename());
        borrowedMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return borrowedMoneyMapper.insertBorrowedMoney(borrowedMoney);
    }

    /**
     * 修改从外部借款信息
     * 
     * @param borrowedMoney 从外部借款信息
     * @return 结果
     */
    @Override
    public int updateBorrowedMoney(BorrowedMoney borrowedMoney)
    {
        borrowedMoney.setUserId(SecurityUtils.getUserId());
        borrowedMoney.setUserName(SecurityUtils.getUserTruename());
        borrowedMoney.setUpdateTime(DateUtils.getNowDate());
        return borrowedMoneyMapper.updateBorrowedMoney(borrowedMoney);
    }

    /**
     * 批量删除从外部借款信息
     * 
     * @param ids 需要删除的从外部借款信息主键
     * @return 结果
     */
    @Override
    public int deleteBorrowedMoneyByIds(Long[] ids)
    {
        return borrowedMoneyMapper.deleteBorrowedMoneyByIds(ids);
    }

    /**
     * 删除从外部借款信息信息
     * 
     * @param id 从外部借款信息主键
     * @return 结果
     */
    @Override
    public int deleteBorrowedMoneyById(Long id)
    {
        return borrowedMoneyMapper.deleteBorrowedMoneyById(id);
    }
}
