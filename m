Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52CF8C1C52
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Sep 2019 09:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729690AbfI3HuU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 Sep 2019 03:50:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:40742 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbfI3HuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Sep 2019 03:50:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=J8ZpJ7IEUIssWYiGn4JUZV8YSFiAwMHHgkpgEGYWdV8=; b=UwrwER/NtRXhHwWf6WsfVKJjs
        g1YGwE2b0Z/H5qRf3xBEVfzHJdQ2l9asPcUOBrBLs0fvl0C49EjyPEz8ttg7IKIl9X24KVwhHOKWZ
        1JDRWPetc99gguSSkg6HfSp5XKAj+WHUVpHcNg3RbIbhC9016ll0RGsvlMxt2A0AZhpynxwivoai1
        otvi8gcnaaD8QUjCVl//jrRTJUrpn70ME853eu7MGgNzH5F2+Bq6K6Ewlctws2uy4HfATWUHssg2y
        XHgeUxWndQbEbmAft2QsaE+4efF4MecXUh0I5moC+qsQWX4EEa+T/NXwrQtwBtiUVvyp09IfNMhz9
        3mvt+prmg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iEqRm-0002AJ-2J; Mon, 30 Sep 2019 07:50:18 +0000
Date:   Mon, 30 Sep 2019 00:50:18 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] libfrog: print library errors
Message-ID: <20190930075018.GC27886@infradead.org>
References: <156944760161.302827.4342305147521200999.stgit@magnolia>
 <156944760784.302827.3061460651592524999.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156944760784.302827.3061460651592524999.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
