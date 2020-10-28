Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A40C829D468
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Oct 2020 22:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbgJ1VwB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 28 Oct 2020 17:52:01 -0400
Received: from casper.infradead.org ([90.155.50.34]:44160 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgJ1Vv7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Oct 2020 17:51:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bDudKI/JCmNt+cEfWDtgsFDiLUl610j3upy/+xiqt24=; b=Rljcc2kvAkpAmrY4WVNECAvMZ5
        mQzjNOpZ+re3HlzKioJhCvqHqglQ17AMF8QCJtAbo5LH56JvWY3LioxfBgmyQTuGnB+9IiIxWdGJV
        nRJTQdVb/bw5PuVBwH1a7d1nRTLa3cBIsbyKyIWzJo49UmWqypnKtMpYr7BkxNkAlSo2hhxvf/BpA
        DQbQqU9+nTCuUmEDBoG04qZEy5so7y+a4HHWvOiaAaR4kViWms8aEq4a1RBwAyJvSrazoaRmSIl+j
        EZMq9Fp81hxeZrCWUx/Hp2My47KPWOFsLVDHiodPFme+E5w5Hn/1szybIcDq3eA2bW/RPbHzYpbML
        OW4Xfczw==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXfwn-0000Do-IG; Wed, 28 Oct 2020 07:32:41 +0000
Date:   Wed, 28 Oct 2020 07:32:41 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1.5/5] mkfs: clarify valid "inherit" option values
Message-ID: <20201028073241.GC32068@infradead.org>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
 <d59f5cbc-42b0-70f0-5471-210f87bf0fe3@sandeen.net>
 <20201027174026.GA1061252@magnolia>
 <707758fc-f3a3-de2c-a8ef-81ec4c939b7c@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <707758fc-f3a3-de2c-a8ef-81ec4c939b7c@sandeen.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:49:08PM -0500, Eric Sandeen wrote:
> Well, "inherit=" /sounds/ like a boolean, so I figured that one needed clarification,
> whereas "size=" seems pretty clear to me, and is described already?
> 
> But perhaps it would be more consistent to keep it all as "=value" and then just
> more clearly describe the valid *inherit= values in the explanatory text... let me try
> a V2 ;)

Yes, that sounds pretty sensible.
