Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C25F3EA0F4
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Aug 2021 10:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234794AbhHLIsR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Aug 2021 04:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234184AbhHLIsQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Aug 2021 04:48:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4AEC061765
        for <linux-xfs@vger.kernel.org>; Thu, 12 Aug 2021 01:47:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=C9DDilYFf06twBT1UPbSZgiEn7
        d0LoQRT+kIdJdC2eLMnhXw+X0QtFyR9oKmpQCINBZ6BLx/tupAeNR7seXQ4RJhZsdmydMJm0FGBvs
        UZTZP8hzMTPPwHMD1UAXYQJ5qp1KmkA0MpVb7ctt5Qk0FZnbCBOS4M07uiPNRrJVUoUXtTxf7JngB
        mw+cLa+UTMMDE0iOqJ30SYDmcs/aqJI1EQp8iCXDESIi0nNRssBF9r0DxK+g+J8vfVm94k8vcjAIN
        KjuJH5wloF/k6jL3huzDKi3u6TVFQIu9Zxv0XSG1tMa6lwaxjAYIIbzmpiIH1Ei3d0ENke3WxC5Tn
        zX2MwOvQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mE6LM-00EMA7-1j; Thu, 12 Aug 2021 08:46:13 +0000
Date:   Thu, 12 Aug 2021 09:45:40 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: add trace point for fs shutdown
Message-ID: <YRTftBdgQRlU5+YF@infradead.org>
References: <162872993519.1220748.15526308019664551101.stgit@magnolia>
 <162872994625.1220748.12679533833955140333.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162872994625.1220748.12679533833955140333.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
