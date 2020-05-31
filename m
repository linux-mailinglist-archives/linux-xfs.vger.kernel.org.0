Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3FA1E98CA
	for <lists+linux-xfs@lfdr.de>; Sun, 31 May 2020 18:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgEaQR3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 31 May 2020 12:17:29 -0400
Received: from out20-98.mail.aliyun.com ([115.124.20.98]:44949 "EHLO
        out20-98.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgEaQR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 31 May 2020 12:17:29 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2005763|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.0219211-0.00198064-0.976098;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03302;MF=guan@eryu.me;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.HgHQtMv_1590941841;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.HgHQtMv_1590941841)
          by smtp.aliyun-inc.com(10.147.41.121);
          Mon, 01 Jun 2020 00:17:22 +0800
Date:   Mon, 1 Jun 2020 00:17:21 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 1/4] xfs: make sure our default quota warning limits and
 grace periods survive quotacheck
Message-ID: <20200531161721.GD3363@desktop>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
 <4b264d49-c5d4-4e0f-3710-38a3e0c321a1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b264d49-c5d4-4e0f-3710-38a3e0c321a1@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 18, 2020 at 02:59:39PM -0500, Eric Sandeen wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> Make sure that the default quota grace period and maximum warning limits
> set by the administrator survive quotacheck.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Ah, this was already merged in last update. Thanks anyway :)

Eryu
