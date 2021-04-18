Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC07363521
	for <lists+linux-xfs@lfdr.de>; Sun, 18 Apr 2021 14:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbhDRMaO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 18 Apr 2021 08:30:14 -0400
Received: from out20-15.mail.aliyun.com ([115.124.20.15]:57872 "EHLO
        out20-15.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbhDRMaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 18 Apr 2021 08:30:14 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2282915|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_social|0.00780885-0.00158498-0.990606;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=guan@eryu.me;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.K.pikHk_1618748984;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.K.pikHk_1618748984)
          by smtp.aliyun-inc.com(10.147.40.233);
          Sun, 18 Apr 2021 20:29:44 +0800
Date:   Sun, 18 Apr 2021 20:29:44 +0800
From:   Eryu Guan <guan@eryu.me>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCHSET 0/9] fstests: random fixes
Message-ID: <YHwmOPwuqvdGjUHT@desktop>
References: <161836227000.2754991.9697150788054520169.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161836227000.2754991.9697150788054520169.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 13, 2021 at 06:04:30PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> This branch contains fixes to various tests to fix miscellaneous test
> bugs and unnecessary regressions when XFS is configured with somewhat
> unusual configurations (e.g. always-cow mode, external logs, and/or
> realtime devices).

Thanks for all the fixes! I've applied all patches except the 5th one.

Thanks,
Eryu
