Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488D42D136A
	for <lists+linux-xfs@lfdr.de>; Mon,  7 Dec 2020 15:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgLGOSV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Dec 2020 09:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727229AbgLGOSV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Dec 2020 09:18:21 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E05C0613D3
        for <linux-xfs@vger.kernel.org>; Mon,  7 Dec 2020 06:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=OgiY8mpSV+a9nIOpARRJIGkyRE
        OwzosZY2Ndhdfd/bIuFlgu+hNdCze59wkx8f+IN7wxTBpjQpl0nN61oKLlgdjtkMya9+YBeR+WVAi
        mweS2UvobA7APEdD8+65dzTGZQBTTwrG3iQ4Ls74/T0nsIwlsXotyrgMq28Kh+Z7TdmzM5nW+ef5d
        QTFhWTxo6cmwt0G4tRcqcEPKq35+h9dQ9IvYpUXaqQ0Iu6a5CGuhLEQHEYCEpzpQXN7sM3NEHBdHx
        eg10QodSyUvut+Ai3gTXP4WKAkZz/+totheJSNnq2Ids/CsGhdfE2EDCIcXUaCd3DzZ2HkekTYZ+U
        HZJ+bUyg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kmHKb-0002XI-Te; Mon, 07 Dec 2020 14:17:37 +0000
Date:   Mon, 7 Dec 2020 14:17:37 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: rename xfs_fc_* back to xfs_fs_*
Message-ID: <20201207141737.GD8637@infradead.org>
References: <160729625074.1608297.13414859761208067117.stgit@magnolia>
 <160729627541.1608297.18095324548384560045.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160729627541.1608297.18095324548384560045.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
