Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD1D183B1
	for <lists+linux-xfs@lfdr.de>; Thu,  9 May 2019 04:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfEICVP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 May 2019 22:21:15 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:19803 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725842AbfEICVP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 22:21:15 -0400
X-IronPort-AV: E=Sophos;i="5.60,448,1549900800"; 
   d="scan'208";a="62195015"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 09 May 2019 10:21:14 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id A0D084CDB74D;
        Thu,  9 May 2019 10:21:13 +0800 (CST)
Received: from [10.167.215.30] (10.167.215.30) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 id 14.3.439.0; Thu, 9 May 2019 10:21:14 +0800
Message-ID: <5CD38E98.8000705@cn.fujitsu.com>
Date:   Thu, 9 May 2019 10:21:12 +0800
From:   xuyang <xuyang2018.jy@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; zh-CN; rv:1.9.2.18) Gecko/20110616 Thunderbird/3.1.11
MIME-Version: 1.0
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
CC:     <guaneryu@gmail.com>, <linux-xfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
Subject: Re: [PATCH 0/3] fstests: various fixes
References: <155724821034.2624631.4172554705843296757.stgit@magnolia>
In-Reply-To: <155724821034.2624631.4172554705843296757.stgit@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.215.30]
X-yoursite-MailScanner-ID: A0D084CDB74D.AF5A5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: xuyang2018.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

on 2019/05/08 0:56, Darrick J. Wong wrote:
> Hi all,
>
> Here are three patches fixing various regressions in xfstests when
> mkfs.xfs defaults to enabling reflink and/or rmap by default.  Most of
> the changes deal with the change in minimum log size requirements.  They
> weren't caught until now because there are a number of tests that call
> mkfs on a loop device or a file without using MKFS_OPTIONS.
>
> If you're going to start using this mess, you probably ought to just
> pull from my git trees, which are linked below.
>
> This is an extraordinary way to destroy everything.  Enjoy!
> Comments and questions are, as always, welcome.
>
> --D
>
> fstests git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
>
>
>
Hi

Tested-by: Yang Xu<xuyang2018.jy@cn.fujitsu.com>



