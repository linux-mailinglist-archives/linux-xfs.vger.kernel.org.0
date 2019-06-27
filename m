Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2148A58237
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 14:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfF0MLC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 08:11:02 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:48673 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726375AbfF0MLC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 08:11:02 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=alvin@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TVLGcQm_1561637456;
Received: from 30.1.89.131(mailfrom:Alvin@linux.alibaba.com fp:SMTPD_---0TVLGcQm_1561637456)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 27 Jun 2019 20:10:57 +0800
From:   Alvin Zheng <Alvin@linux.alibaba.com>
Subject: [backport request][stable] xfs: xfstests generic/538 failed on xfs
To:     gregkh <gregkh@linuxfoundation.org>,
        linux-xfs <linux-xfs@vger.kernel.org>, bfoster@redhat.com
Cc:     "joseph.qi" <joseph.qi@linux.alibaba.com>,
        caspar <caspar@linux.alibaba.com>
Message-ID: <a665a93a-0bf8-aedb-2ba3-d4b2fb672970@linux.alibaba.com>
Date:   Thu, 27 Jun 2019 20:10:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

     I  was using kernel v4.19.y and found that it cannot pass the 
generic/538 due to data corruption. I notice that upstream has fix this 
issue with commit 2032a8a27b5cc0f578d37fa16fa2494b80a0d00a. Will v4.19.y 
backport this patch?

Best regards,

Alvin

