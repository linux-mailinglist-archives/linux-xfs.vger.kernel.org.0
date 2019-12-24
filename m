Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABE812A149
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Dec 2019 13:26:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbfLXM0p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Dec 2019 07:26:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbfLXM0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Dec 2019 07:26:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=6zGw2RfGtYBeKVrMnpqNCpE7sXo6Z9yDlsY89bCQj+I=; b=Mh0cIWlQ0Lf1Rh9jib+OJDem6
        ue5+cfWbrMQJGu7F6kKAeGf+U6UIkGjeg6BBCRIxt9hjpc2ORmogeGhD5ayBywt+PC4FUHuZQszN8
        mrkPAPXT0GXCrbQzdXql6+iiHLZ0P9E3wcbAA40ZRzKVkuTuTGi+kGjqOOxGFMt8kNcrmN+BZqK+r
        6g7gt64d3Aje8B1loSnmLRTFuRYy56abNCcMxPDVTA7NfSHSVg5BXVhG4ARhNpLxl4S57gV5mfNBz
        3lCNzHqYZwDSuvXmTQhdnK5haVFwoSxSPG4sNWz+X4BlRQtZACnrq4+tf/6TsLGVpdX1I4BMkyrW8
        +d6JMNsjw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ijjGv-0006tL-3R; Tue, 24 Dec 2019 12:26:45 +0000
Date:   Tue, 24 Dec 2019 04:26:45 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v5 09/14] xfs: Factor up trans roll from
 xfs_attr3_leaf_setflag
Message-ID: <20191224122645.GG18379@infradead.org>
References: <20191212041513.13855-1-allison.henderson@oracle.com>
 <20191212041513.13855-10-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191212041513.13855-10-allison.henderson@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> @@ -2854,10 +2854,7 @@ xfs_attr3_leaf_setflag(
>  			 XFS_DA_LOGRANGE(leaf, name_rmt, sizeof(*name_rmt)));
>  	}
>  
> -	/*
> -	 * Commit the flag value change and start the next trans in series.
> -	 */
> -	return xfs_trans_roll_inode(&args->trans, args->dp);
> +	return error;

error is always 0 here.
