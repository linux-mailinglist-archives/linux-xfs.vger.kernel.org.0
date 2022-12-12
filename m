Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E17A649847
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Dec 2022 04:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiLLDnp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 11 Dec 2022 22:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLLDno (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 11 Dec 2022 22:43:44 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B74FBC21;
        Sun, 11 Dec 2022 19:43:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=ziyangzhang@linux.alibaba.com;NM=0;PH=DS;RN=5;SR=0;TI=SMTPD_---0VX0z3ea_1670816620;
Received: from 30.97.57.7(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VX0z3ea_1670816620)
          by smtp.aliyun-inc.com;
          Mon, 12 Dec 2022 11:43:41 +0800
Message-ID: <ada237c4-65e2-3125-1a60-cfaa17efd83a@linux.alibaba.com>
Date:   Mon, 12 Dec 2022 11:43:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH V5 2/2] common/populate: Ensure that S_IFDIR.FMT_BTREE is
 in btree format
Content-Language: en-US
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        hsiangkao@linux.alibaba.com, "Darrick J. Wong" <djwong@kernel.org>
References: <20221208072843.1866615-1-ZiyangZhang@linux.alibaba.com>
 <20221208072843.1866615-3-ZiyangZhang@linux.alibaba.com>
 <Y5NkVRNhQgZpWNMj@magnolia> <20221210135724.owsxdqiirtkqsv6e@zlang-mailbox>
 <Y5VAss77Xm8JUu4r@magnolia> <20221211110125.zpc4csv6hw5ibsbu@zlang-mailbox>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20221211110125.zpc4csv6hw5ibsbu@zlang-mailbox>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2022/12/11 19:01, Zorro Lang wrote:
> Yes, and this helper's name should be _xfs_get_inode_core_bytes(), not
> _xfs_inode_core_bytes(). I didn't find _xfs_inode_core_bytes from current
> fstests. So it should be:
> 
>   local icore_size="$(_xfs_get_inode_core_bytes $SCRATCH_MNT)"
> 
> Hi Ziyang,
> 
> Please modify this place, and check all other places which call
> _xfs_get_inode_core_bytes and _xfs_get_inode_size, to make sure
> they're all changed correctly.
> 
> Thanks,
> Zorro

Hi Zorro,

You are correct. Sorry for my mistake.

I should use _xfs_get_inode_core_bytes here and add a path
argument($SCRATCH_MNT). I will send a new version.

Regards,
Zhang
