package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.OilCard;
import org.dzu.system.mapper.OilCardMapper;
import org.dzu.system.service.IOilCardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
/**
 * 加油卡信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OilCardServiceImpl implements IOilCardService
{
    @Autowired
    private OilCardMapper oilCardMapper;

    /**
     * 查询加油卡信息
     *
     * @param id 加油卡信息主键
     * @return 加油卡信息
     */
    @Override
    public OilCard selectOilCardById(Long id)
    {
        return oilCardMapper.selectOilCardById(id);
    }

    /**
     * 查询加油卡信息列表
     *
     * @param oilCard 加油卡信息
     * @return 加油卡信息
     */
    @Override
    public List<OilCard> selectOilCardList(OilCard oilCard)
    {
        return oilCardMapper.selectOilCardList(oilCard);
    }

    /**
     * 新增加油卡信息
     *
     * @param oilCard 加油卡信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int insertOilCard(OilCard oilCard)
    {
        // 根据卡号搜索，如果搜索到id不是这个但是卡号相同的`，提示已经有了
        QueryWrapper<OilCard> query = new QueryWrapper<OilCard>().eq("oilCardNo", oilCard.getOilCardNo()).ne("id", oilCard.getId());
        if(oilCardMapper.selectCount(query)>0){
            throw new ServiceException("对应卡号已经录入");
        }

        oilCard.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilCard.setUserId(SecurityUtils.getUserId());
        oilCard.setUserName(SecurityUtils.getUserTruename());
        oilCard.setDelFlag(Long.valueOf(DelConstants.NODEL));
        try {
            return oilCardMapper.insertOilCard(oilCard);
        } catch (DuplicateKeyException e) {
            throw new ServiceException("对应卡号已经录入");
        }
    }

    /**
     * 修改加油卡信息
     * 
     * @param oilCard 加油卡信息
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int updateOilCard(OilCard oilCard)
    {
        // 根据卡号搜索，如果搜索到id不是这个但是卡号相同的`，提示已经有了
        QueryWrapper<OilCard> query = new QueryWrapper<OilCard>().eq("oilCardNo", oilCard.getOilCardNo()).ne("id", oilCard.getId());
        oilCard.setUserId(SecurityUtils.getUserId());
        oilCard.setUserName(SecurityUtils.getUserTruename());
        oilCard.setUpdateTime(DateUtils.getNowDate());

        // 修改金额操作只能在充值和圈存模块进行
        oilCard.setMoneyAmount(null);
        try {
            return oilCardMapper.updateOilCard(oilCard);
        } catch (DuplicateKeyException e) {
            throw new RuntimeException("对应卡号已经录入");
        }
    }

    /**
     * 批量删除加油卡信息
     * 
     * @param ids 需要删除的加油卡信息主键
     * @return 结果
     */
    @Override
    public int deleteOilCardByIds(Long[] ids)
    {
        return oilCardMapper.deleteOilCardByIds(ids);
    }

    /**
     * 删除加油卡信息信息
     * 
     * @param id 加油卡信息主键
     * @return 结果
     */
    @Override
    public int deleteOilCardById(Long id)
    {
        return oilCardMapper.deleteOilCardById(id);
    }
}
