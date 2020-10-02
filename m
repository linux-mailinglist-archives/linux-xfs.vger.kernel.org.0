Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EAE2819F9
	for <lists+linux-xfs@lfdr.de>; Fri,  2 Oct 2020 19:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgJBRoL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 2 Oct 2020 13:44:11 -0400
Received: from sandeen.net ([63.231.237.45]:45598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBRoL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Oct 2020 13:44:11 -0400
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 65BF74872C8;
        Fri,  2 Oct 2020 12:43:20 -0500 (CDT)
To:     Thomas Deutschmann <whissi@gentoo.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <ab3571df-40c1-dad8-800f-48c1a64355fe@gentoo.org>
From:   Eric Sandeen <sandeen@sandeen.net>
Subject: Re: xfsdump: Building inventory: gcc: fatal error: no input files
Message-ID: <f0f731e9-95ec-2a8e-6f8c-7df7980e53ec@sandeen.net>
Date:   Fri, 2 Oct 2020 12:44:10 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <ab3571df-40c1-dad8-800f-48c1a64355fe@gentoo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/12/20 9:26 AM, Thomas Deutschmann wrote:
> Hi,
> 
> not sure if anybody has noticed yet but when building xfsdump, there
> seems to be a non-fatal build error:
> 
>> Building inventory
>>     [LTDEP]
>> gcc: fatal error: no input files
>> compilation terminated.

Thanks - sorry for the very slow response here.  The files in inventory/ get shared
between dump/ and restore/ and get built in those dirs; I'll figure out how to suppress
this error.

-Eric
