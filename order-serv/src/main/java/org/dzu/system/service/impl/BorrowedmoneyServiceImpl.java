package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.BorrowedmoneyMapper;
import org.dzu.system.domain.Borrowedmoney;
import org.dzu.system.service.IBorrowedmoneyService;

/**
 * 借入金钱Service业务层处理
 * 
 * @author ml
 * @date 2024-07-18
 */
@Service
public class BorrowedmoneyServiceImpl implements IBorrowedmoneyService 
{
    @Autowired
    private BorrowedmoneyMapper borrowedmoneyMapper;

    /**
     * 查询借入金钱
     * 
     * @param id 借入金钱主键
     * @return 借入金钱
     */
    @Override
    public Borrowedmoney selectBorrowedmoneyById(Long id)
    {
        return borrowedmoneyMapper.selectBorrowedmoneyById(id);
    }

    /**
     * 查询借入金钱列表
     * 
     * @param borrowedmoney 借入金钱
     * @return 借入金钱
     */
    @Override
    public List<Borrowedmoney> selectBorrowedmoneyList(Borrowedmoney borrowedmoney)
    {
        return borrowedmoneyMapper.selectBorrowedmoneyList(borrowedmoney);
    }

    /**
     * 新增借入金钱
     * 
     * @param borrowedmoney 借入金钱
     * @return 结果
     */
    @Override
    public int insertBorrowedmoney(Borrowedmoney borrowedmoney)
    {
        return borrowedmoneyMapper.insertBorrowedmoney(borrowedmoney);
    }

    /**
     * 修改借入金钱
     * 
     * @param borrowedmoney 借入金钱
     * @return 结果
     */
    @Override
    public int updateBorrowedmoney(Borrowedmoney borrowedmoney)
    {
        borrowedmoney.setUpdateTime(DateUtils.getNowDate());
        return borrowedmoneyMapper.updateBorrowedmoney(borrowedmoney);
    }

    /**
     * 批量删除借入金钱
     * 
     * @param ids 需要删除的借入金钱主键
     * @return 结果
     */
    @Override
    public int deleteBorrowedmoneyByIds(Long[] ids)
    {
        return borrowedmoneyMapper.deleteBorrowedmoneyByIds(ids);
    }

    /**
     * 删除借入金钱信息
     * 
     * @param id 借入金钱主键
     * @return 结果
     */
    @Override
    public int deleteBorrowedmoneyById(Long id)
    {
        return borrowedmoneyMapper.deleteBorrowedmoneyById(id);
    }
}
