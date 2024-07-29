package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BorrowedmoneyMapper;
import org.dzu.system.domain.Borrowedmoney;
import org.dzu.system.service.IBorrowedmoneyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 从外部借入款、贷款Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class BorrowedmoneyServiceImpl implements IBorrowedmoneyService
{
    @Autowired
    private BorrowedmoneyMapper borrowedmoneyMapper;

    /**
     * 查询从外部借入款、贷款
     *
     * @param id 从外部借入款、贷款主键
     * @return 从外部借入款、贷款
     */
    @Override
    public Borrowedmoney selectBorrowedmoneyById(Long id)
    {
        return borrowedmoneyMapper.selectBorrowedmoneyById(id);
    }

    /**
     * 查询从外部借入款、贷款列表
     *
     * @param borrowedmoney 从外部借入款、贷款
     * @return 从外部借入款、贷款
     */
    @Override
    public List<Borrowedmoney> selectBorrowedmoneyList(Borrowedmoney borrowedmoney)
    {
        return borrowedmoneyMapper.selectBorrowedmoneyList(borrowedmoney);
    }

    /**
     * 新增从外部借入款、贷款
     *
     * @param borrowedmoney 从外部借入款、贷款
     * @return 结果
     */
    @Override
    public int insertBorrowedmoney(Borrowedmoney borrowedmoney)
    {
        borrowedmoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        borrowedmoney.setUserId(SecurityUtils.getUserId());
        borrowedmoney.setUserName(SecurityUtils.getUserTruename());
        borrowedmoney.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return borrowedmoneyMapper.insertBorrowedmoney(borrowedmoney);
    }

    /**
     * 修改从外部借入款、贷款
     * 
     * @param borrowedmoney 从外部借入款、贷款
     * @return 结果
     */
    @Override
    public int updateBorrowedmoney(Borrowedmoney borrowedmoney)
    {
        borrowedmoney.setUserId(SecurityUtils.getUserId());
        borrowedmoney.setUserName(SecurityUtils.getUserTruename());
        borrowedmoney.setUpdateTime(DateUtils.getNowDate());
        return borrowedmoneyMapper.updateBorrowedmoney(borrowedmoney);
    }

    /**
     * 批量删除从外部借入款、贷款
     * 
     * @param ids 需要删除的从外部借入款、贷款主键
     * @return 结果
     */
    @Override
    public int deleteBorrowedmoneyByIds(Long[] ids)
    {
        return borrowedmoneyMapper.deleteBorrowedmoneyByIds(ids);
    }

    /**
     * 删除从外部借入款、贷款信息
     * 
     * @param id 从外部借入款、贷款主键
     * @return 结果
     */
    @Override
    public int deleteBorrowedmoneyById(Long id)
    {
        return borrowedmoneyMapper.deleteBorrowedmoneyById(id);
    }
}
