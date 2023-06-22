Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2820E739854
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jun 2023 09:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjFVHoS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jun 2023 03:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbjFVHoR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2023 03:44:17 -0400
Received: from out28-87.mail.aliyun.com (out28-87.mail.aliyun.com [115.124.28.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD5DFC
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jun 2023 00:44:14 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.3369995|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.160606-0.00368825-0.835706;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047206;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.Taz9Ikt_1687419845;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Taz9Ikt_1687419845)
          by smtp.aliyun-inc.com;
          Thu, 22 Jun 2023 15:44:10 +0800
Date:   Thu, 22 Jun 2023 15:44:10 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Masahiko Sawada <sawada.mshk@gmail.com>
Subject: Re: Question on slow fallocate
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
References: <CAD21AoCWW20ga6GKR+7RwRtvPU0VyFt3_acut_y+Fg7E-4nzWw@mail.gmail.com>
Message-Id: <20230622154405.9696.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.81.04 [en]
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> Hi all,
> 
> When testing PostgreSQL, I found a performance degradation. After some
> investigation, it ultimately reached the attached simple C program and
> turned out that the performance degradation happens on only the xfs
> filesystem (doesn't happen on neither ext3 nor ext4). In short, the
> program alternately does two things to extend a file (1) call
> posix_fallocate() to extend by 8192 bytes and (2) call pwrite() to
> extend by 8192 bytes. If I do only either (1) or (2), the program is
> completed in 2 sec, but if I do (1) and (2) alternatively, it is
> completed in 90 sec.
> 
> $ gcc -o test test.c
> $ time ./test test.1 1
> total   200000
> fallocate       200000
> filewrite       0
> 
> real    0m1.305s
> user    0m0.050s
> sys     0m1.255s
> 
> $ time ./test test.2 2
> total   200000
> fallocate       100000
> filewrite       100000
> 
> real    1m29.222s
> user    0m0.139s
> sys     0m3.139s
> 
> Why does it take so long in the latter case? and are there any
> workaround or configuration changes to deal with it?
> 

I test it on xfs linux 6.1.35 and 6.4-rc7

the result is almost same.

$ time ./test test.1 1
real    0m1.382s

$ time ./test test.2 2
real    0m9.262s

linunx kernel version please.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2023/06/22

