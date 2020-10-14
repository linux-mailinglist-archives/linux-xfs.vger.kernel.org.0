Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACEF828D901
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Oct 2020 05:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729449AbgJNDcM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Oct 2020 23:32:12 -0400
Received: from out20-110.mail.aliyun.com ([115.124.20.110]:47844 "EHLO
        out20-110.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729395AbgJNDcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 23:32:11 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1063232|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_enroll_verification|0.0163685-0.00131857-0.982313;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.IiwWrR6_1602646328;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.IiwWrR6_1602646328)
          by smtp.aliyun-inc.com(10.147.41.120);
          Wed, 14 Oct 2020 11:32:09 +0800
Date:   Wed, 14 Oct 2020 11:32:11 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Dave Chinner <david@fromorbit.com>
Subject: Re: dbench throughput on xfs over hardware limit(6Gb/s)
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20201013230521.GB7391@dread.disaster.area>
References: <20201013221113.F0A0.409509F4@e16-tech.com> <20201013230521.GB7391@dread.disaster.area>
Message-Id: <20201014113211.2372.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


> On Tue, Oct 13, 2020 at 10:11:13PM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > dbench throughput on xfs over hardware limit(6Gb/s=750MB/s).
> > 
> > Is this a bug or some feature of performance optimization?
> 
> dbench measures page cache throughput, not physical IO throughput.
> This sort of results is expected.

We use 'dbench -s', so it should be physical IO.
   -s     Use synchronous file IO on all file operations.

we check 'dbench -s' with 'strace -ff -o s.log',
we can see 'O_SYNC' in openat().


Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2020/10/14



