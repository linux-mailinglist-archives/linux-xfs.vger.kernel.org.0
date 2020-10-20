Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65B228CFE5
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Oct 2020 16:11:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388311AbgJMOLP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Oct 2020 10:11:15 -0400
Received: from out20-99.mail.aliyun.com ([115.124.20.99]:43418 "EHLO
        out20-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388308AbgJMOLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Oct 2020 10:11:15 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1553294|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0274543-0.00126902-0.971277;FP=12781844343017034617|3|2|3|0|-1|-1|-1;HT=ay29a033018047204;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.Iih1ZlF_1602598270;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.Iih1ZlF_1602598270)
          by smtp.aliyun-inc.com(10.147.44.145);
          Tue, 13 Oct 2020 22:11:11 +0800
Date:   Tue, 13 Oct 2020 22:11:13 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: dbench throughput on xfs over hardware limit(6Gb/s)
Message-Id: <20201013221113.F0A0.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.75.01 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

dbench throughput on xfs over hardware limit(6Gb/s=750MB/s).

Is this a bug or some feature of performance optimization?

Disk: TOSHIBA  PX05SMQ040
This is a 12Gb/s SAS SSD disk, but connect to 6Gb/s SAS HBA,
so it works with 6Gb/s.

dbench -s -t 60 -D /xfs 32
#Throughput 884.406 MB/sec (sync open)

dbench -s -t 60 -D /xfs 1
#Throughput 149.172 MB/sec (sync open)

we test the same disk with ext4 filesystem, 
the throughput is very close to, but less than the hardware limit.

dbench -s -t 60 -D /ext4 32
#Throughput 740.95 MB/sec (sync open)

dbench -s -t 60 -D /ext4 1
#Throughput 124.67 MB/sec (sync open)

linux kernel: 5.4.70, 5.9.0

Best Regards
�����
2020/10/13

--------------------------------------
��������Ƽ����޹�˾
�����	wangyugui@e16-tech.com
�绰��+86-136-71123776

