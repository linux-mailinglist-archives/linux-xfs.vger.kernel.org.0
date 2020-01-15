Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A56E13CCDE
	for <lists+linux-xfs@lfdr.de>; Wed, 15 Jan 2020 20:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgAOTKR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Jan 2020 14:10:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:51060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgAOTKR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jan 2020 14:10:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=ZDJOSafqk/u32H3N0lx/uHZ6G
        nTmC6KHIlQ4OAnhRdJfsFaZZkn7fIAyQeR4mMwAFAhGZ/4CeuhbAkG5zZgiyZXToSwpgD1dTChdxi
        jIxDOeAScs0PDycdr7OA7c/Bs6E5eXJc9OlwTDIT9yemEX9XtTpCpnUW9ajxf9dLdtt/OIOFJm4s8
        kBzcH1T9jNZv4Ap9jCNzGvoKf+3sGeKE1ffljnt8Y1DMgqaUTxl8+bGJr9pyNFb/0woZ7pSDbp7Qr
        kNj/VM5ldk3366kU2bxoy9xyRTPaNRHBG+7TgmOmKU/AqE2Pkk81ZxBwavl03wdCVCE9CaklHHDcO
        fQYlwSStA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iro3U-0001SZ-Rw; Wed, 15 Jan 2020 19:10:16 +0000
Date:   Wed, 15 Jan 2020 11:10:16 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/7] xfs: fix memory corruption during remote attr value
 buffer invalidation
Message-ID: <20200115191016.GA29741@infradead.org>
References: <157910777330.2028015.5017943601641757827.stgit@magnolia>
 <157910778615.2028015.18198430975182240025.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157910778615.2028015.18198430975182240025.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
