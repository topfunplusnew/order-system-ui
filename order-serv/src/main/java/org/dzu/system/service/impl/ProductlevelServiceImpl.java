package org.dzu.system.service.impl;

import org.dzu.common.constant.DelCOnstants;
import org.dzu.common.core.domain.entity.SysUser;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.Productlevel;
import org.dzu.system.mapper.ProductlevelMapper;
import org.dzu.system.service.IProductlevelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 产品级别管理Service业务层处理
 *
 * @author ml
 * @date 2024-07-19
 */
@Service
public class ProductlevelServiceImpl implements IProductlevelService {
    @Autowired
    private ProductlevelMapper productlevelMapper;

    /**
     * 查询产品级别管理
     *
     * @param id 产品级别管理主键
     * @return 产品级别管理
     */
    @Override
    public Productlevel selectProductlevelById(Long id) {
        return productlevelMapper.selectProductlevelById(id);
    }

    /**
     * 查询产品级别管理列表
     *
     * @param productlevel 产品级别管理
     * @return 产品级别管理
     */
    @Override
    public List<Productlevel> selectProductlevelList(Productlevel productlevel) {
        return productlevelMapper.selectProductlevelList(productlevel);
    }

    /**
     * 新增产品级别管理
     *
     * @param productlevel 产品级别管理
     * @return 结果
     */
    @Override
    public int insertProductlevel(Productlevel productlevel) {
        // 设置添加时间
        productlevel.setAddtime(DateUtils.getTime());
        // 设置操作人员属性
        updateProductlevel(productlevel);
        //设置删除标记
        productlevel.setDelFlag(Long.valueOf(DelCOnstants.NODEL));

        return productlevelMapper.insertProductlevel(productlevel);
    }

    /**
     * 修改产品级别管理
     *
     * @param productlevel 产品级别管理
     * @return 结果
     */
    @Override
    public int updateProductlevel(Productlevel productlevel) {
        // 设置操作人员属性
        updateModifypersonneldata(productlevel);
        //设置删除标记
        productlevel.setDelFlag(Long.valueOf(DelCOnstants.NODEL));

        productlevel.setUpdateTime(DateUtils.getNowDate());
        return productlevelMapper.updateProductlevel(productlevel);
    }

    /**
     * 批量删除产品级别管理
     *
     * @param ids 需要删除的产品级别管理主键
     * @return 结果
     */
    @Override
    public int deleteProductlevelByIds(Long[] ids) {
        return productlevelMapper.deleteProductlevelByIds(ids);
    }

    /**
     * 删除产品级别管理信息
     *
     * @param id 产品级别管理主键
     * @return 结果
     */
    @Override
    public int deleteProductlevelById(Long id) {
        return productlevelMapper.deleteProductlevelById(id);
    }

    private void updateModifypersonneldata(Productlevel productlevel) {
        // 设置操作人员+添加时间
        SysUser user = SecurityUtils.getLoginUser().getUser();
        productlevel.setUserId(user.getUserId());
        productlevel.setUserName(user.getTrueName());
    }
}
