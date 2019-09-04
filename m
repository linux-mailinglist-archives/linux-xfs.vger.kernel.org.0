Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9EA7B4F
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 08:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfIDGNl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Sep 2019 02:13:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfIDGNl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 02:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=g4J0KNjpci7q2fXnEPcSF7Zpw
        yNLHNeBgSMnUMd0hMvb9KDgrVMFck6NFsySxMLzyvfmkIs6lW45k9RaJOJndIiCsTRP4mi1tYD87Z
        3MrGQUbPSGL33OM4m8FRqCaLUYEI+69mhlzVihHWM6iT2F0qRLTYW0fsPv2tXRluY97Gn4qUMjaQY
        jc82FISnqULgBfotOEdX3FsakY14RgNGErbdFaaZyBzNcLzNqO3nneV00p9v/lesOpPNltlF+yqk5
        V4MbZc1UBz1hOomqjd0/dwkwmn6i8WM8sqI2Nm85jF3jT2TkiMen1DkObUYapksAZ4OLCtX/fXYKl
        Mf34DKF5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5OY0-0007Hv-PY; Wed, 04 Sep 2019 06:13:40 +0000
Date:   Tue, 3 Sep 2019 23:13:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/7] xfs: factor callbacks out of xlog_state_do_callback()
Message-ID: <20190904061340.GD12591@infradead.org>
References: <20190904042451.9314-1-david@fromorbit.com>
 <20190904042451.9314-5-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904042451.9314-5-david@fromorbit.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
