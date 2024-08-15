package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.DelConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.common.utils.StringUtils;
import org.dzu.system.domain.BusinessTrip;
import org.dzu.system.domain.OilCard;
import org.dzu.system.domain.OilCardConsume;
import org.dzu.system.mapper.OilCardConsumeMapper;
import org.dzu.system.mapper.OilCardMapper;
import org.dzu.system.service.IOilCardConsumeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;

/**
 * 加油卡消费信息Service业务层处理
 *
 * @author ml
 * @date 2024-07-29
 */
@Service
public class OilCardConsumeServiceImpl implements IOilCardConsumeService
{
    @Autowired
    private OilCardConsumeMapper oilCardConsumeMapper;
    @Autowired
    private OilCardMapper oilCardMapper;
    @Autowired
    private BusinessTripServiceImpl businessTripServiceImpl;
    @Autowired
    private OilCardServiceImpl oilCardServiceImpl;

    /**
     * 查询加油卡消费信息
     *
     * @param id 加油卡消费信息主键
     * @return 加油卡消费信息
     */
    @Override
    public OilCardConsume selectOilCardConsumeById(Long id)
    {
        return oilCardConsumeMapper.selectOilCardConsumeById(id);
    }

    /**
     * 查询加油卡消费信息列表
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 加油卡消费信息
     */
    @Override
    public List<OilCardConsume> selectOilCardConsumeList(OilCardConsume oilCardConsume)
    {
        return oilCardConsumeMapper.selectOilCardConsumeList(oilCardConsume);
    }

    /**
     * 新增加油卡消费信息
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    @Override
    public int insertOilCardConsume(OilCardConsume oilCardConsume)
    {
        // 设置基础信息
        oilCardConsume.setAddtime(String.valueOf(DateUtils.getNowDate()));
        oilCardConsume.setUserId(SecurityUtils.getUserId());
        oilCardConsume.setUserName(SecurityUtils.getUserTruename());
        oilCardConsume.setDelFlag(Long.valueOf(DelConstants.NODEL));
        // 对数字进行强转校验,如果catch到异常则封装成另一种
        Double rechargeMoney = 0.0;
        Double refuelingMoney = 0.0;
        try{
            rechargeMoney = Double.parseDouble(oilCardConsume.getRechargeMoney());
            refuelingMoney = Double.parseDouble(oilCardConsume.getRefuelingMoney());
        }catch (Exception e){
            throw new ServiceException("请输入正确的数字");
        }

        // 检测对应的出差id是否存在
        if(StringUtils.isNull(oilCardConsume.getbTripId())){
            throw new ServiceException("必须选择对应的出差记录");
        }
        BusinessTrip businessTrip = businessTripServiceImpl.selectBusinessTripById(Long.valueOf(oilCardConsume.getbTripId()));

        if(StringUtils.isNull(businessTrip)){
            throw new ServiceException("对应的出差记录不存在");
        }

        //确定对应的油卡存在
        QueryWrapper<OilCard> query = new QueryWrapper<OilCard>().eq("oilCardNo", oilCardConsume.getOilCardNo()).ne("delFlag", DelConstants.DEL);
        if(oilCardMapper.selectCount(query)==0){
            throw new ServiceException("对应油卡不存在");
        }


        // 进行油卡金额的变动
        oilCardServiceImpl.updateOilCardMoney(oilCardConsume.getOilCardNo(), rechargeMoney - refuelingMoney);


        return oilCardConsumeMapper.insertOilCardConsume(oilCardConsume);
    }


    /**
     * 修改加油卡消费信息
     *
     * @param oilCardConsume 加油卡消费信息
     * @return 结果
     */
    @Override
    public int updateOilCardConsume(OilCardConsume oilCardConsume)
    {
        // 获取对应的旧信息
        OilCardConsume old = oilCardConsumeMapper.selectOilCardConsumeById(oilCardConsume.getId());

        // 对数字进行强转校验,如果catch到异常则封装成另一种
        Double rechargeMoney = 0.0;
        Double refuelingMoney = 0.0;
        try{
            rechargeMoney = Double.parseDouble(oilCardConsume.getRechargeMoney());
            refuelingMoney = Double.parseDouble(oilCardConsume.getRefuelingMoney());
        }catch (Exception e){
            throw new ServiceException("请输入正确的数字");
        }
        // 检测前后的出差id是否一致
        if(!old.getbTripId().equals(oilCardConsume.getbTripId())){
            throw new ServiceException("不支持修改信息对应的出差记录");
        }

        // 检测是否修改油卡号
        if(!old.getOilCardNo().equals(oilCardConsume.getOilCardNo())){
            throw new ServiceException("若需修改油卡编号,请删除本信息后重新录入");
        }

        // 进行油卡金额的变动,此时先依据旧信息模拟还原金额,再依据新信息进行金额变动
        oilCardServiceImpl.updateOilCardMoney(old.getOilCardNo(), Double.parseDouble(old.getRechargeMoney()) - Double.parseDouble(old.getRefuelingMoney())+rechargeMoney-refuelingMoney);



        return oilCardConsumeMapper.updateOilCardConsume(oilCardConsume);
    }

    /**
     * 批量删除加油卡消费信息
     *
     * @param ids 需要删除的加油卡消费信息主键
     * @return 结果
     */
    @Override
    @Transactional
    public int deleteOilCardConsumeByIds(Long[] ids)
    {
        // 搜索全部的数据用来归还金额
        List<OilCardConsume> oilCardConsumes = oilCardConsumeMapper.selectBatchIds(Arrays.asList(ids));
        for (OilCardConsume oilCardConsume : oilCardConsumes) {
            oilCardServiceImpl.updateOilCardMoney(oilCardConsume.getOilCardNo(), Double.parseDouble(oilCardConsume.getRefuelingMoney()) - Double.parseDouble(oilCardConsume.getRechargeMoney()));
        }
        return oilCardConsumeMapper.deleteOilCardConsumeByIds(ids);
    }

}
