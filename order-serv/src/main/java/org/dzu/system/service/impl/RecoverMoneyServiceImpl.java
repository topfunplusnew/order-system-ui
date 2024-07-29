package org.dzu.system.service.impl;

import java.util.List;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.dzu.system.mapper.RecoverMoneyMapper;
import org.dzu.system.domain.RecoverMoney;
import org.dzu.system.service.IRecoverMoneyService;
 
import org.dzu.common.constant.DelConstants;
/**
 * 借出款收回信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class RecoverMoneyServiceImpl implements IRecoverMoneyService
{
    @Autowired
    private RecoverMoneyMapper recoverMoneyMapper;

    /**
     * 查询借出款收回信息
     *
     * @param id 借出款收回信息主键
     * @return 借出款收回信息
     */
    @Override
    public RecoverMoney selectRecoverMoneyById(Long id)
    {
        return recoverMoneyMapper.selectRecoverMoneyById(id);
    }

    /**
     * 查询借出款收回信息列表
     *
     * @param recoverMoney 借出款收回信息
     * @return 借出款收回信息
     */
    @Override
    public List<RecoverMoney> selectRecoverMoneyList(RecoverMoney recoverMoney)
    {
        return recoverMoneyMapper.selectRecoverMoneyList(recoverMoney);
    }

    /**
     * 新增借出款收回信息
     *
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    @Override
    public int insertRecoverMoney(RecoverMoney recoverMoney)
    {
        recoverMoney.setAddtime(String.valueOf(DateUtils.getNowDate()));
        recoverMoney.setUserId(SecurityUtils.getUserId());
        recoverMoney.setUserName(SecurityUtils.getUserTruename());
        recoverMoney.setDelFlag(Long.valueOf(DelConstants.NODEL));
        return recoverMoneyMapper.insertRecoverMoney(recoverMoney);
    }

    /**
     * 修改借出款收回信息
     * 
     * @param recoverMoney 借出款收回信息
     * @return 结果
     */
    @Override
    public int updateRecoverMoney(RecoverMoney recoverMoney)
    {
        recoverMoney.setUserId(SecurityUtils.getUserId());
        recoverMoney.setUserName(SecurityUtils.getUserTruename());
        recoverMoney.setUpdateTime(DateUtils.getNowDate());
        return recoverMoneyMapper.updateRecoverMoney(recoverMoney);
    }

    /**
     * 批量删除借出款收回信息
     * 
     * @param ids 需要删除的借出款收回信息主键
     * @return 结果
     */
    @Override
    public int deleteRecoverMoneyByIds(Long[] ids)
    {
        return recoverMoneyMapper.deleteRecoverMoneyByIds(ids);
    }

    /**
     * 删除借出款收回信息信息
     * 
     * @param id 借出款收回信息主键
     * @return 结果
     */
    @Override
    public int deleteRecoverMoneyById(Long id)
    {
        return recoverMoneyMapper.deleteRecoverMoneyById(id);
    }
}
