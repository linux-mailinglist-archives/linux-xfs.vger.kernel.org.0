Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC026D55B
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 09:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgIQHz7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 03:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgIQHz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 03:55:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023DAC06174A;
        Thu, 17 Sep 2020 00:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nPhjXL93m5DUmj7oaN9/ZITnOh3Qq3Sfff2+1DngSM4=; b=Kak58sizJIiPs2fmy4uw/C5dgF
        JWqzUypxGAeH8SYCsgun99dcfhLPNWK7XfSCkLLZu/fQI9atMMzkP4DxlHH0j4dOoLhYnslcQio0u
        ofDiUCdpENkmndJ7AyuCn1eg7vHvbqwPbFq3wNKxkWY1XkTPUKwUVart1xReOz4ySNQ5/USOLKm/y
        6les0BQJac6/IjywBYF8MrbAP1p0yEQsbCSzyqOHa3WteBsvHG/jno65j+OwIW6EU+uWJAOUUG02M
        h6PMmdSzyHMvNk6g8rgZfeQZ7GFRTnHOtkJ3jW8cYM2kfr4ifptOUj5w/GdRaxl1SWR6e6EhtKfSP
        lCVj1jag==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kIolC-0007J7-2t; Thu, 17 Sep 2020 07:55:18 +0000
Date:   Thu, 17 Sep 2020 08:55:18 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH 09/24] xfs/070: add scratch log device options to direct
 repair invocation
Message-ID: <20200917075518.GI26262@infradead.org>
References: <160013417420.2923511.6825722200699287884.stgit@magnolia>
 <160013423329.2923511.3252823001209034556.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160013423329.2923511.3252823001209034556.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 14, 2020 at 06:43:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
