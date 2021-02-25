Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5286D324BEB
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 09:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235561AbhBYITv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 03:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbhBYITu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:19:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A66C06174A
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=qwWULaSvMH8uDYgGBCR3pJgaMY
        67qgayC7HcB/P+0T9YeV9ytX2Sje/2RzztVK9IxxV/vgTEIOiQ/Upe7P3bQBCf4GSf4/IFEgT+sxr
        RpMQMxOxzdddsh5jBBSxGybZ/gC35Z6eGdy6mDRyOfXnOhAr97Z2zJTiLNf3j92fnVB1Q5Ex/PwhZ
        vVDwdU2cmSbJW3jJ3vctFNciDu2IyHqGiGEB0i2GDKtNnAkiPgJ2cEi7plk87C/bUo7BaCGCj4dwq
        fDpRVEFLvEu5/WyC2WhWGOA9l+0AS/aWqh2Bk5VOxv5Ksu7P72OSaXbmJ8V+G4clWNd4b1LaHqkTP
        biLPNLpg==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBr7-00ASPl-QS; Thu, 25 Feb 2021 08:18:46 +0000
Date:   Thu, 25 Feb 2021 08:18:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     sandeen@sandeen.net, Eric Sandeen <sandeen@redhat.com>,
        Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_repair: factor phase transitions into a helper
Message-ID: <20210225081841.GN2483198@infradead.org>
References: <161404926046.425602.766097344183886137.stgit@magnolia>
 <161404927772.425602.2186366769310581007.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161404927772.425602.2186366769310581007.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
