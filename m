Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5593A17A156
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Mar 2020 09:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725880AbgCEIae (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Mar 2020 03:30:34 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:33314 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgCEIae (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 5 Mar 2020 03:30:34 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DF22EE12EFBA5624C16C;
        Thu,  5 Mar 2020 16:30:27 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 5 Mar 2020
 16:30:17 +0800
To:     Dave Chinner <david@fromorbit.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Subject: Questions about CVE-2016-8660
Message-ID: <2cb951f9-bd4e-a182-e7d3-6a903ff49535@huawei.com>
Date:   Thu, 5 Mar 2020 16:30:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Recently I am studying CVE-2016-8660, in https://seclists.org/oss-sec/2016/q4/118,
it says that this bug is introduced by commit fc0561cefc04 ("xfs: optimise away log forces on timestamp updates for fdatasync").
And in https://patchwork.kernel.org/patch/9363339/#19693745, david correction has nothing to do with this commit,
and is a page lock order bug in the XFS seek hole/data implementation(demsg is in http://people.redhat.com/qcai/tmp/dmesg-sync,
Unfortunately, it is not accessible now, I do not understand why this is a page lock order bug).

Is this CVE solved? Can I see the demsg in other way? thanks.


