Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A86F298F
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Nov 2019 09:45:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733210AbfKGIpG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 Nov 2019 03:45:06 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:44938 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727120AbfKGIpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Nov 2019 03:45:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=fsIomRsSqDh4ajZBO7hKAfKAN
        k4DFFiOs0L6p8BUWH7Bu1Hj9Bq/qGjtcwz/2E/5a0EyuxGF0dlpoa55FuTNqQLyjdhp4EKPm1DTJE
        DjjcLdrIgClmjPxxmi1yAMxwJ/PEkpbuJfq2YP0CvnQ8Ua7xQByJehMEVEEGPa8KssRDrG9WO1bx/
        SgV5JHtouFDSa6uHZ9QQkZECtGqaHPeF39JqLu0+vwwXDLjWjlcfiO49v77I4l/dvTjBHJQAaPuqO
        LuoHPrfcSnTEkJCB8NTqTM/YMiPd3KmFQtA5xhsoMIQCdCSDaqD1j/sgW4taFxf9Up1EmY6vUCKlL
        BE2NgB2mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSdPd-0000rI-Np; Thu, 07 Nov 2019 08:45:05 +0000
Date:   Thu, 7 Nov 2019 00:45:05 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     hch@infradead.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: periodically yield scrub threads to the
 scheduler
Message-ID: <20191107084505.GA1936@infradead.org>
References: <157309569968.45477.14151251025953231838.stgit@magnolia>
 <157309570624.45477.13114580991647804387.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157309570624.45477.13114580991647804387.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
