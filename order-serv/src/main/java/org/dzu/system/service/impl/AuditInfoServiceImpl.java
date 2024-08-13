package org.dzu.system.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import org.dzu.common.constant.AuditStateConstants;
import org.dzu.common.exception.ServiceException;
import org.dzu.common.utils.DateUtils;
import org.dzu.common.utils.SecurityUtils;
import org.dzu.system.domain.AuditInfo;
import org.dzu.system.domain.AuditInfoGroupedResult;
import org.dzu.system.domain.Auditflow;
import org.dzu.system.domain.PaymentApply;
import org.dzu.system.mapper.AuditInfoMapper;
import org.dzu.system.mapper.PaymentApplyMapper;
import org.dzu.system.service.IAuditInfoService;
import org.dzu.system.service.IAuditflowService;
import org.dzu.system.service.IPaymentApplyService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import static org.dzu.common.utils.PageUtils.startPage;

/**
 * 审核流程Service业务层处理
 *
 * @author ml
 * @date 2024-08-01
 */
@Service
public class AuditInfoServiceImpl implements IAuditInfoService {
    @Autowired
    private AuditInfoMapper auditInfoMapper;

    @Autowired
    private IAuditflowService auditflowService;

    @Autowired
    private IPaymentApplyService paymentApplyService;

    @Autowired
    private PaymentApplyMapper paymentApplyMapper;

    /**
     * 查询审核流程
     *
     * @param id 审核流程主键
     * @return 审核流程
     */
    @Override
    public AuditInfo selectAuditInfoById(Long id) {
        return auditInfoMapper.selectAuditInfoById(id);
    }

    /**
     * 查询审核流程列表
     *
     * @param auditInfo 审核流程
     * @return 审核流程
     */
    @Override
    public List<AuditInfo> selectAuditInfoList(AuditInfo auditInfo) {
        return auditInfoMapper.selectAuditInfoList(auditInfo);
    }


    /**
     * 查询审核流程列表,但是按applyid分组
     *
     * @param auditInfo 审核流程
     * @return 审核流程
     */
    @Override
    public List<AuditInfoGroupedResult> selectAuditInfoGroupByApplyId(AuditInfo auditInfo) {
        startPage();
        // 获取applyId列表
        List<Map<String, Object>> results = auditInfoMapper.selectApplyIdList(auditInfo);



        // 因为分页插件的分页参数已经被搜索results消耗,所以此处检测是否为0,否则会导致下方sql全表打包分组
        if(results.isEmpty()){
            throw new ServiceException("本次选择的筛选条件下无任何可返回数据!");
        }

        // Extract unique applyIds
        List<Long> applyIds = results.stream()
                .map(result -> {
                    Object applyIdObj = result.get("applyId");
                    if (applyIdObj instanceof Integer) {
                        return ((Integer) applyIdObj).longValue();
                    } else if (applyIdObj instanceof Long) {
                        return (Long) applyIdObj;
                    } else if (applyIdObj instanceof String) {
                        return Long.valueOf((String) applyIdObj);
                    } else {
                        throw new ServiceException("Unexpected type for applyId: " + applyIdObj.getClass().getName());
                    }
                })
                .collect(Collectors.toList());

        // 获取 AuditInfo 对象列表
        List<AuditInfo> auditInfos = auditInfoMapper.selectAuditInfoGroupedByApplyId(applyIds);

        // 按 applyId 对 AuditInfo 对象进行分组
        Map<Long, List<AuditInfo>> groupedAuditInfos = auditInfos.stream()
                .collect(Collectors.groupingBy(AuditInfo::getApplyID));

        //将分组数据转换为 AuditInfoGroupedResult 列表
        List<AuditInfoGroupedResult> groupedResults = groupedAuditInfos.entrySet().stream()
                .map(entry -> {
                    AuditInfoGroupedResult groupedResult = new AuditInfoGroupedResult();
                    groupedResult.setAuditInfos(entry.getValue());
                    return groupedResult;
                })
                .collect(Collectors.toList());

        return groupedResults;
    }


    /**
     * 新增审核流程
     *
     * @param paymentApply 审核流程
     * @return 结果
     */
    @Override
    public int insertAuditInfo(PaymentApply paymentApply) {
        // 审核是由申请形成的
        AuditInfo auditInfo = new AuditInfo();
        auditInfo.setApplyID(paymentApply.getId());

        // 获取审核流程第一步
        List<Auditflow> flows = auditflowService.selectAuditflowList(null);
        if (flows.size() == 0) {
            throw new RuntimeException("审核流程未设置，请等待审核流程设置完成后再提交申请");
        }
        Auditflow auditflow = flows.get(0);
        BeanUtils.copyProperties(auditflow, auditInfo);

        // 新增加的一定是审核中
        auditInfo.setCheckState(AuditStateConstants.CHECK_STATE_ING);

        auditInfo.setAuditdate(DateUtils.getNowDate());
        auditInfo.setUserId(SecurityUtils.getUserId());
        auditInfo.setUserName(SecurityUtils.getUserTruename());
        return auditInfoMapper.insertAuditInfo(auditInfo);
    }

    /**
     * 修改审核流程
     *
     * @param auditInfo 审核流程
     * @return 结果
     */
    @Override
    @Transactional(isolation = Isolation.SERIALIZABLE, rollbackFor = Exception.class)
    public int updateAuditInfo(AuditInfo auditInfo) {
        // 填充一下基本信息
        auditInfo.setAuditdate(DateUtils.getNowDate());
        auditInfo.setUserId(SecurityUtils.getUserId());
        auditInfo.setUserName(SecurityUtils.getUserTruename());

        // 获取旧数据
        AuditInfo oldAuditInfo = auditInfoMapper.selectAuditInfoById(auditInfo.getId());

        // 如果是审核结束，则直接抛出异常，不允许修改
        if (oldAuditInfo.getSubmitflag().equals(AuditStateConstants.SUBMIT_STATE_END)) {
            throw new RuntimeException("审核已结束，不允许修改");
        }

        // 判断是否是允许的用户，只有允许的审核人才能进行审核
        // 获取审核人字符串(用户id，中间用英文逗号分割)
        String[] checkUserIds = oldAuditInfo.getAuditauthority().split(",");
        boolean contains = Arrays.asList(checkUserIds).contains(String.valueOf(SecurityUtils.getUserId()));

        // 如果本人不在里面并且不是管理员，抛出异常
        if (!contains && SecurityUtils.isAdmin(SecurityUtils.getUserId()) == false) {
            throw new RuntimeException("您不是本阶段的审核人，无法进行审核");
        }

        if (!auditInfo.getCheckState().equals(AuditStateConstants.CHECK_STATE_ING)) {
            // 不是审核中则必定是审核结束的两种状态
            auditInfo.setSubmitflag(AuditStateConstants.SUBMIT_STATE_END);
            // 同时判断是否通过
            if (auditInfo.getCheckState().equals(AuditStateConstants.CHECK_STATE_PASS)) {
                // 判断是不是最后一步
                if (oldAuditInfo.getStep() == oldAuditInfo.getStepnum()) {
                    // 如果是最后一步，则结束 保存数据到申请表中为通过
                    paymentApplyService.auditPass(auditInfo.getApplyID());
                } else {
                    // 如果不是最后一步，则开启下一个审核流程同时
                    // 获取下一个审核流程
                    Auditflow nextAuditflow = auditflowService.selectAuditflowByStep(oldAuditInfo.getStep() + 1);
                    if (nextAuditflow == null) {
                        throw new RuntimeException("审核流程设置错误，请联系管理员");
                    }
                    // 新增下一个审核流程
                    AuditInfo nextAuditInfo = new AuditInfo();
                    BeanUtils.copyProperties(nextAuditflow, nextAuditInfo);
                    nextAuditInfo.setApplyID(oldAuditInfo.getApplyID());
                    nextAuditInfo.setCheckState(AuditStateConstants.CHECK_STATE_ING);
                    auditInfoMapper.insertAuditInfo(nextAuditInfo);
                }
            } else {
                // 如果是未通过，则结束
                // 保存数据到申请表中为未通过
                PaymentApply updateInfo = new PaymentApply();
                updateInfo.setId(oldAuditInfo.getApplyID());
                updateInfo.setCheckState(AuditStateConstants.CHECK_STATE_NOT_PASS);
                updateInfo.setSubmitflag(AuditStateConstants.SUBMIT_STATE_END);
                paymentApplyService.updatePaymentApply(updateInfo);
            }
        } else {
            // 如果是审核中，则不允许本次操作
            throw new ServiceException("请选择审核状态为通过或未通过");
        }
        return auditInfoMapper.updateAuditInfo(auditInfo);
    }

    /**
     * 批量删除审核流程
     *
     * @param ids 需要删除的审核流程主键
     * @return 结果
     */
    @Override
    public int deleteAuditInfoByIds(Long[] ids) {
        return auditInfoMapper.deleteAuditInfoByIds(ids);
    }

    /**
     * 删除审核流程信息
     *
     * @param id 审核流程主键
     * @return 结果
     */
    @Override
    public int deleteAuditInfoById(Long id) {
        return auditInfoMapper.deleteAuditInfoById(id);
    }

    @Override
    public void updateAuditInfoToError() {
        QueryWrapper<AuditInfo> query = new QueryWrapper<>();
        // 设置所有submitflag不为1的信息的checkState为未通过,auditcomment为因修改审核流程，系统自动关闭
        query.ne("submitflag", AuditStateConstants.SUBMIT_STATE_END);
        AuditInfo auditInfo = new AuditInfo();
        auditInfo.setCheckState(AuditStateConstants.CHECK_STATE_NOT_PASS);
        auditInfo.setAuditcomment("因审核流程被修改，系统自动关闭，请重新申请");
        auditInfoMapper.update(auditInfo, query);

        // 关闭目前的付款申请
        QueryWrapper<PaymentApply> applyQuery = new QueryWrapper<>();
        applyQuery.ne("checkState", AuditStateConstants.CHECK_STATE_PASS);
        PaymentApply paymentApply = new PaymentApply();
        paymentApply.setCheckState(AuditStateConstants.CHECK_STATE_NOT_PASS);
        paymentApply.setComments("因审核流程被修改，系统自动关闭，请重新申请");
        paymentApplyMapper.update(paymentApply, applyQuery);


    }
}
