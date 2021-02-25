Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080B0324CCC
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 10:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhBYJZk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Feb 2021 04:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbhBYJZT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 04:25:19 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C43EC061574
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 01:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=TuVYesfWXg3jO81Ha6g0P/dIHN
        lJ0ZZMCMWpLKszA8cngPDVeql5G47kscNjcmF5ptm915G1wrkDd8JK4tDNYqYXOXUBn8DVGhfwILP
        MNdJakRhWGLCf/XPz98PVasuck3OBzpRCZ4J6mIxhJioZe3zBKSnsUDEwFQEQbneXm9CcRH5gSxul
        DSXx03rPJmv93uLcpcsGLNR0KFtfc5V1RXWKq62ercU/cc47vFYemR7XwtnK9bTRjgdT4D5Z1qJCZ
        /q5KLvRE49NWi5k2WbGnsq0ClFncjqNYtKWta4YDSAKrYqrd3909qPbxTJVHZ1EiLSsDg++bwOzZC
        Rc1rvu2w==;
Received: from 213-225-9-156.nat.highway.a1.net ([213.225.9.156] helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFCsX-00AWAi-GH; Thu, 25 Feb 2021 09:24:19 +0000
Date:   Thu, 25 Feb 2021 10:21:56 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/13] xfs: log ticket region debug is largely useless
Message-ID: <YDdsNFp3sL5zO8u7@infradead.org>
References: <20210224063459.3436852-1-david@fromorbit.com>
 <20210224063459.3436852-9-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224063459.3436852-9-david@fromorbit.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
