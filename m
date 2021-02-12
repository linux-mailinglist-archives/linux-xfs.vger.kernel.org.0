Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4531A764
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Feb 2021 23:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbhBLWQc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Feb 2021 17:16:32 -0500
Received: from sandeen.net ([63.231.237.45]:49568 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230307AbhBLWQZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Feb 2021 17:16:25 -0500
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.146])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id F3A2058DC9E;
        Fri, 12 Feb 2021 16:15:41 -0600 (CST)
Subject: Re: [PATCH] include/buildrules: substitute ".o" for ".lo" only at the
 very end
To:     Markus Mayer <mmayer@broadcom.com>,
        Linux XFS <linux-xfs@vger.kernel.org>
References: <20210212204849.1556406-1-mmayer@broadcom.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Message-ID: <05ce1b1a-8b05-4496-9b14-b215cef15c66@sandeen.net>
Date:   Fri, 12 Feb 2021 16:15:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210212204849.1556406-1-mmayer@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/12/21 2:48 PM, Markus Mayer wrote:
> To prevent issues when the ".o" extension appears in a directory path,
> ensure that the ".o" -> ".lo" substitution is only performed for the
> final file extension.
> 
> Signed-off-by: Markus Mayer <mmayer@broadcom.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

> ---
> 
> I ran into a build issue with our setup due to the original regex below.
> It was mangling the path to header files by substituting ".o" with ".lo"
> one too many times.
> 
> This patch resolves the issue. Also, it seems like the right thing to do
> to limit substitutions to the final file extension in a path.
> 
>  include/buildrules | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/buildrules b/include/buildrules
> index 7a139ff07de8..357e0a18504f 100644
> --- a/include/buildrules
> +++ b/include/buildrules
> @@ -133,7 +133,7 @@ rmltdep:
>  	$(Q)rm -f .ltdep
>  
>  .ltdep: $(CFILES) $(HFILES)
> -	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o,\1.lo,' > .ltdep
> +	$(Q)$(MAKEDEP) $(CFILES) | $(SED) -e 's,^\([^:]*\)\.o$$,\1.lo,' > .ltdep
>  
>  depend: rmdep .dep
>  
> 
