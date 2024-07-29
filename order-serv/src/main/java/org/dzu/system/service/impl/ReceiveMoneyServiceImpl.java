package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.ReceiveMoneyMapper;
import org.dzu.system.domain.ReceiveMoney;
import org.dzu.system.service.IReceiveMoneyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 收款信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class ReceiveMoneyServiceImpl implements IReceiveMoneyService
{
    @Autowired
    private ReceiveMoneyMapper receiveMoneyMapper;

    /**
     * 查询收款信息
     *
     * @param id 收款信息主键
     * @return 收款信息
     */
    @Override
    public ReceiveMoney selectReceiveMoneyById(Long id)
    {
        return receiveMoneyMapper.selectReceiveMoneyById(id);
    }

    /**
     * 查询收款信息列表
     *
     * @param receiveMoney 收款信息
     * @return 收款信息
     */
    @Override
    public List<ReceiveMoney> selectReceiveMoneyList(ReceiveMoney receiveMoney)
    {
        return receiveMoneyMapper.selectReceiveMoneyList(receiveMoney);
    }

    /**
     * 新增收款信息
     *
     * @param receiveMoney 收款信息
     * @return 结果
     */
    @Override
    public int insertReceiveMoney(ReceiveMoney receiveMoney)
    {
        receiveMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        receiveMoney.setUserId(SecurityUtils.getUserId());
        receiveMoney.setUserName(SecurityUtils.getUserTruename());
        receiveMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return receiveMoneyMapper.insertReceiveMoney(receiveMoney);
    }

    /**
     * 修改收款信息
     * 
     * @param receiveMoney 收款信息
     * @return 结果
     */
    @Override
    public int updateReceiveMoney(ReceiveMoney receiveMoney)
    {
        receiveMoney.setUserId(SecurityUtils.getUserId());
        receiveMoney.setUserName(SecurityUtils.getUserTruename());
        receiveMoney.setUpdateTime(DateUtils.getNowDate());
        return receiveMoneyMapper.updateReceiveMoney(receiveMoney);
    }

    /**
     * 批量删除收款信息
     * 
     * @param ids 需要删除的收款信息主键
     * @return 结果
     */
    @Override
    public int deleteReceiveMoneyByIds(Long[] ids)
    {
        return receiveMoneyMapper.deleteReceiveMoneyByIds(ids);
    }

    /**
     * 删除收款信息信息
     * 
     * @param id 收款信息主键
     * @return 结果
     */
    @Override
    public int deleteReceiveMoneyById(Long id)
    {
        return receiveMoneyMapper.deleteReceiveMoneyById(id);
    }
}
