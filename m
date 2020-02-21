Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A4A1680DD
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:54:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgBUOyh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:54:37 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:55650 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUOyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:54:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9D9SGKbYFeazhNpGO0TJS37RDcvOL3S9UF9GW8S80DY=; b=NP5hiEwkp1QT1cbr6de7YCAI7W
        xZQZbxwy2VpL+NkBs8UWkVRBWP721VidR/1h1Yu+aufQVfQ+kH3dCTmlzBrJwzZEzG3qw6YVQ0Dov
        eGLdt4TvEP4NqhCPELM+pToD6I9NnS9035k3bllMhWh/fikgmoO8Xty7CB2AmgMgd+YXe7gIZqwKW
        DmW8Lz4Rf1VKyhsQKzLKl1h40YWrFSltE3RP3VZWS7ydq+X2X3RU1TlYrSNPgAi1M67BiCPtDJ6Q6
        L9zmgr4sMDfl31rKXq/kywoTP8o30nlJ/DNG8XOASFFm2DPp0/Ig8pJwhoqu8avYut5OBOME1xqSz
        HNPDFzGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59hM-0003Ys-EL; Fri, 21 Feb 2020 14:54:36 +0000
Date:   Fri, 21 Feb 2020 06:54:36 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 16/18] libxfs: hide libxfs_getbuf_flags
Message-ID: <20200221145436.GN15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216305519.602314.7497657265091013884.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216305519.602314.7497657265091013884.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:44:15PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Hide this function since it's internal to rdwr.c.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
