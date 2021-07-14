Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F223C3C7F15
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 09:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhGNHPI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 03:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbhGNHPB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 03:15:01 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EB5C061574
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 00:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=P6BMsOwEI25oO37YRpY/Mz5hC6
        I836Khk+YgpcbGNzCGex/wrprPVmyGmxX8hvJxgdBa15wkgV1qY4jXarN8IVWfmo/wxLVbdMT2anK
        MZrERbJwAp4PpeTaUiE5lf+XoA4iAKd5TSMbUAhtBiYAEdVviNq9q1+E83S9dFdy48/dcstIivSwR
        3Q3iyqLUWBaDHpSm7aTk2mFnRm/ZpofV8Gu0ngR5fk5LvtKF1yvWCN9wiHrKtpcqOYTtOcWfaWn3Z
        H34UZYhQDEV+SznMb6okpNgPakfVr8MSNBwGYa7GhfTwoJuz743It9KBpDXmKEiaHlld1ox2D/LuE
        JNZeLwew==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3Z3c-001x06-2n; Wed, 14 Jul 2021 07:11:54 +0000
Date:   Wed, 14 Jul 2021 08:11:48 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 10/16] xfs: convert xfs_fs_geometry to use mount feature
 checks
Message-ID: <YO6ONATbJ8ytL4Ri@infradead.org>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-11-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-11-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
