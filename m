Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0207C149196
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Jan 2020 00:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729398AbgAXXHq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jan 2020 18:07:46 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41908 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729293AbgAXXHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jan 2020 18:07:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=TJrjg10t2eilhMEVkydoAe5Lg
        Uu4yFDHfl2jN7rG8ZDSOz5pjK5rj7Y1zkTZ2uK5+7R4aXDbSCl8zlxqH3XAx0BgzWiL7iGTrkj1sI
        Z4N/0bDb54TpE1xB5a/y8vCroi5tAZovvX2SE4Ubz3QoJG9bSvT4Nbp7Ig8RgLV6IeFZaIfoMuFII
        wOofMnFE4fHWlU1mX7m8Tz58ZLrA2lRIkYUtq1i6Xr7ePZA6qGLXCr1uiS7cbpZ3AjpxA9TobwyBw
        kwICPJaThV0TRJNJ4ExIvsCPIyxM6Fo8jlmORmvU73TVZQoq3SVJdgC+Uy6gxW1LzYnPkOY5F9EoS
        /9vlI9ypw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iv83E-0002V0-Sk; Fri, 24 Jan 2020 23:07:44 +0000
Date:   Fri, 24 Jan 2020 15:07:44 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 03/12] xfs: make xfs_buf_read_map return an error code
Message-ID: <20200124230744.GB20014@infradead.org>
References: <157984313582.3139258.1136501362141645797.stgit@magnolia>
 <157984315522.3139258.1946613629222213561.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157984315522.3139258.1946613629222213561.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
