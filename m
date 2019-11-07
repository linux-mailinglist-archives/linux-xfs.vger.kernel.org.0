Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0AACF2925
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 09:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKGIcS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 03:32:18 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:58168 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfKGIcS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:32:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=yhVxFenIgPub/w/35qpJsH+EleYVEBaF1uzR5/OHDEM=; b=Kpr+faKvZwzrToNQ85VnsqEgT
        HZBz91poe6POoU0a5Bz9yFVN/p7Bqpr4vl5AEV/bsAPhPx24GpU/Yho4l5vDdfrTnhb/O32HkmigR
        GJvv7V4PbSWfcwkcJMDEVXPSx2KLs52mK1rvtZajaDBhv10Z+WqDP6EzGTrb2CozghFbK+Gbozetk
        3BI0e+8dkl70pD77Ws0d8ufFBBVueKC/2Fi9XlYwpOQuaYm97caHpS0CQijom5h8x42yiWIEdc80r
        socGtWs0EFuBpTB54Lvg+TVZ8XIvB3wKBVzIypRTz6G+66NsnPiMY3VZrMYsZTME7z346Rd5STXEG
        8ixZ5akOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdDF-0003S4-MD; Thu, 07 Nov 2019 08:32:17 +0000
Date:   Thu, 7 Nov 2019 00:32:17 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/6] xfs: fix missing header includes
Message-ID: <20191107083217.GB6729@infradead.org>
References: <157309573874.46520.18107298984141751739.stgit@magnolia>
 <157309575167.46520.15760576794168756429.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309575167.46520.15760576794168756429.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
