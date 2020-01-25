Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35B22149833
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Jan 2020 00:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgAYXQm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 25 Jan 2020 18:16:42 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47198 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727496AbgAYXQm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 25 Jan 2020 18:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=Q/rAzpp3pt8XUwGLl31DRlaqP
        Rt9E/wcE96eez7wVt5q7hl0joNpHOCfs59oUnCxJwKFJM8V44lfklHqPpGhSvRQVW8CROQ3mu9fy3
        OvHRK/ZUqA/ZnERCZmorPjHrFk+mQLEJIcPFrX2NbTO+nvswwKU1Wux6Gyz8RpuEqt+up8e32hATa
        +mdb+CoA6JVZDc8UIpi6fjX5xcPWWUuVH+n7PTz0m6+MIon+AfFCWHk7HIxCs42TNUXmswL16Hbk/
        ipUuEHwKoqch63jVMpWJcIY2QKOTQ5D2RJ46ZaE3a97Qnc/ji+DR3CI9HP3jPKjaxrooDPQ5+KmqB
        7ldc7a2IA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ivUfR-0006hC-5J; Sat, 25 Jan 2020 23:16:41 +0000
Date:   Sat, 25 Jan 2020 15:16:41 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/8] man: reformat xfs_quota commands in the manpage for
 testing
Message-ID: <20200125231641.GG15222@infradead.org>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
 <157982501072.2765410.10319214860660759283.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157982501072.2765410.10319214860660759283.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
